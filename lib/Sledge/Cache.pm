package Sledge::Cache;
use strict;
use warnings;
our $VERSION = '0.04';
use Sledge::Exceptions;

sub new {
    my ($class, $page) = @_;

    my $self = bless {
        _data => {},
        _page => $page,
    }, $class;
    $self->_init($page);

    return $self;
}

# developer APIs:
sub _init                { Sledge::Exception::AbstractMethod->throw }
sub _set                 { Sledge::Exception::AbstractMethod->throw }
sub _get                 { Sledge::Exception::AbstractMethod->throw }
sub _remove              { Sledge::Exception::AbstractMethod->throw }
sub _get_key {
    my ($self, $key) = @_;

    my $base = ref $self->{_page} || $self->{_page};
    $base =~ s/::Pages.*//g;
    return "${base}_$key";
}

sub get_callback {
    my ($self, $key, $callback, $expiry)  = @_;

    my $data = $self->param($key);
    return $data if defined $data;

    $data = $callback->();
    $self->param($key => $data, $expiry) if defined $data;

    return $data;
}

# public APIs:
sub param {
    my ($self, $key, $val, $exptime) = @_;

    if (defined $val) { # setter
        $self->_set($self->_get_key($key) => $val, $exptime);
    } else {           # getter
        return $self->_get($self->_get_key($key));
    }
}

sub remove {
    my ($self, $key) = @_;

    return $self->_remove($self->_get_key($key));
}

1;
__END__

=head1 NAME

Sledge::Cache - Abstract base class for sledge's cache class

=head1 SYNOPSIS

    package Sledge::Cache::Foo;
    use base 'Sledge::Cache';
    sub _init {
        my ($self, $page) = @_;
        # initialize
    }
    sub _get {
        my ($self, $key) = @_;
        # get value
    }
    sub _set {
        my ($self, $key, $val, $exptime) = @_;
        # set value
    }
    sub _remove {
        my ($self, $key) = @_;
        # remove value
    }

    package Your::Pages;
    use Sledge::Cache::Foo;
    sub create_cache { Sledge::Cache::Foo->new(shift) }
    sub dispatch_shokotan {
        my $self = shift;
        my $shokotan = $self->cache->get_callback(
            shokotan => sub { Your::Data->retrieve('shokotan') },
        );
        $self->tmpl->param(shokotan => $shokotan);
    }

=head1 DESCRIPTION

Sledge::Cache is abstract base class for sledge's cache class.

=head1 METHODS

=head2 new

Returns a new Sledge::Cache object.

=head2 get_callback

    my $shokotan = $self->cache->get_callback(
        shokotan => sub { Your::Data->retrieve('shokotan') }, 5*60
    );

This checks if a Shokotan can be found to match the information passed, and if not store it.

=head2 param

    my $shokotan = $self->cache->param('shokotan');
    $self->cache->param('shokotan' => $shokotan);

Get or set the cache(likes Sledge::Pages::Base, Sledge::Template, etc.).

=head2 remove

    $self->cache->remove('shokotan');

Deletes a key.

=head1 ABSTRACT METHODS

=head2 _init(PAGES)

=head2 _get(KEY)

=head2 _set(KEY, VALUE, EXPTIME)

=head2 _remove(KEY)

You'll must override in your child class.

=head1 AUTHOR

MATSUNO Tokuhiro E<lt>tokuhiro at mobilefactory.jpE<gt>

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 SEE ALSO

L<Sledge::Plugin::Cache>, L<Bundle::Sledge>

=cut
