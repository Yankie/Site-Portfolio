package Site::Portfolio::Controller::Blog;
use Moose;
use namespace::autoclean;

BEGIN {extends 'Catalyst::Controller'; }
extends 'Catalyst::Controller::HTML::FormFu';

=head1 NAME

Site::Portfolio::Controller::Blog - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

sub index :Path :Args(0) {
	my ( $self, $c ) = @_;
	$c->stash->{page_title} = $c->loc( 'page.blog.title');
    $c->stash->{page_message} = $c->loc('page.blog.message');

	my $articles = $c->model('PortfolioDb::Article');
	$c->stash->{articles} = $articles;
}

=head2 view

=cut

sub view : Local {
	my ($self, $c, $id) = @_;
	my $article = $c->model('PortfolioDb::Article')->find({id => $id});

	$c->stash->{per_page} = 4;
	$c->stash->{article} = $article;
	$c->stash->{page_title} = $c->loc('page.blog.view.title [_1]', $article->title);
# 	$c->stash->{page_message} = $c->loc('page.blog.view.message [_1]', $article->title);
}

=head2 add

=cut

sub add : Local FormConfig('blog/edit.yml') {
	my ($self, $c) = @_;

	## Check Authorization
	if ( $c->can('check_user_roles') && !$c->check_user_roles('admin') ) {
		$c->flash->{error} = $c->loc('ui.error.blog.no.add.permissions'); #"You don't have proper permissions to add photos here";
		$c->response->redirect( $c->uri_for_action('/blog') );
		$c->detach();
	}
	$c->go('edit', []);
}

=head2 edit

=cut

sub edit : Local FormConfig('blog/edit.yml') {
	my ($self, $c, $id) = @_;

	## Check Authorization
	if ( $c->can('check_user_roles') && !$c->check_user_roles('admin') ) {
		$c->flash->{error} = $c->loc('ui.error.blog.no.edit.permissions'); #"You don't have proper permissions to add photos here";
		$c->response->redirect( ($id ? $c->uri_for_action('/blog/view', $id) : $c->uri_for_action('/blog')));
		$c->detach();
	}
	my $form = $c->stash->{form};
	my $article = $c->model('PortfolioDb::Article')->find_or_new({id => $id});
	$c->stash->{article} = $article;
	if ($form->submitted_and_valid) {
		# form was submitted and it validated
		$article->title($form->param_value('title'));
		$article->description($form->param_value( 'description'));
		$article->update_or_insert;
		$c->flash->{success} =  ($id > 0 ? $c->loc( 'ui.message.blog.update.success [_1]', $article->title) : $c->loc( 'ui.message.blog.add.success [_1]', $article->title));
		$c->response->redirect($c->uri_for_action('/blog'));
		$c->detach();

	}
	else {
		# first time through, or invalid form
		if(!$id){
			$c->stash->{page_title} = $c->loc('page.blog.add.title');
			$c->stash->{page_message} = $c->loc('page.blog.add.message');
		}
		else {
			$c->stash->{page_title} = $c->loc('page.blog.edit.title [_1]', $article->title);
			$c->stash->{page_message} = $c->loc('page.blog.edit.message [_1]', $article->title);
		}
		$form->default_values({'title'  => $article->title, 'description' => $article->description});
	}
}

=head2 delete

=cut

sub delete : Local {
	my ($self, $c, $id) = @_;

	if ( $c->can('check_user_roles') && !$c->check_user_roles("admin") ) {
		$c->flash->{error} =  $c->loc('ui.error.blog.no.delete.permissions'); #"You don't have proper permissions to delete images.";
	}
	else {

		my $article = $c->model('PortfolioDb::Article')->find({id => $id});
		$c->stash->{gallery} = $article;
		if($article){
			$c->flash->{success} = $c->loc('ui.message.blog.delete.success [_1]', $article->title);
			$article->delete;
		}
		else {
			$c->flash->{error} = $c->loc('ui.message.blog.no [_1]', $id ); #"No such gallery - $id";
		}
	}
	$c->response->redirect($c->uri_for_action('/blog'));
	$c->detach();
}

=head1 AUTHOR

Pavel Yefimov

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
