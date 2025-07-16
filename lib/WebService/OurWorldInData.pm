package WebService::OurWorldInData;
# ABSTRACT: Perl library to connect with Our World in Data
# https://ourworldindata.org

our $VERSION = '0.01';

use v5.12;
use Moo;
use JSON qw(decode_json);

use Carp;
use Feature::Compat::Try;

my $DEBUG = 0;

has ua    => (
    is => 'ro',
    default => sub {
        require HTTP::Tiny;
        require IO::Socket::SSL;
        HTTP::Tiny->new;
    },
);

has base_url => (
    is      => 'ro',
    default => sub { 'https://ourworldindata.org' },
);

sub get_response {
    my ($self, $url) = @_;

    my $res = $self->ua->get( $url );

    if    ($res->{success})  { warn $res->{content} if $DEBUG > 1 }
    elsif ($res->{redirects}) { carp 'Redirected: ', $res->headers->location if $DEBUG }
    else  { carp 'HTTP Error: ', $res->{status}, $res->{reason}; }

    return $res->{content};
}

sub post_response {
    my ($self, $url) = @_;

    my $res = $self->ua->post( $url );

    return $res->{content};
}

1; # Perl is my Igor

=head1 SYNOPSIS

    my $owid = WebService::OurWorldInData->new({
        proxy => '...', # your web proxy
    });

    my $search = $owid->search( q => 'star', fl => 'bibcode' );

=head1 DESCRIPTION

This is a base class for Our World in Data APIs. You probably should be
using the L<WebService::OurWorldInData::Chart> class.

=head2 Getting Started

Documentation for L<Chart API|https://docs.owid.io/projects/etl/api/chart-api/>

=head2 Proxies

The UA gets the proxy from your environment variable
_or_
create a HTTP::Tiny object with the {all_proxy => "proxy url"} attribute
and pass that to the C<ua> attribute of the API constructor

    $tiny_ua = HTTP::Tiny->new({all_proxy => "http://proxy.url"});
    $client = WebService::OurWorldInData->new({ ua => $tiny_ua });

=head1 SEE ALSO

I am stealing from NeilB's L<WebService::HackerNews> to learn how he does
APIs with L<HTTP::Tiny>. This is a re-write from my first version in Mojo.

=head2 Terms and Conditions


=cut
