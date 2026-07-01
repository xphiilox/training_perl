use strict;
use warnings;
use utf8;
use Test::More;
use Test::Mojo;

require './app.pl';

my $t = Test::Mojo->new;

$t->get_ok('/')
    ->status_is(200)
    ->text_is('h1' => 'Training Perl Home')
    ->content_like(qr/Perl練習環境のホーム画面/);

done_testing;
