package Sledge::Cache;
use strict;
use warnings;
our $VERSION = '0.02';
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
    $self->param($key => $data) if defined $data;

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

=head1 DESCRIPTION

Sledge::Cache is abstract base class for sledge's cache class.

=head1 AUTHOR

MATSUNO Tokuhiro E<lt>tokuhiro at mobilefactory.jpE<gt>

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 SEE ALSO

L<Sledge::Plugin::Cache>, L<Bundle::Sledge>

=cut
