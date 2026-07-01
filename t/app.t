use strict;
use warnings;
use utf8;
use Test::More;

require './public/index.cgi';

my $html = render_home();

like $html, qr/<title>Training Perl Home<\/title>/, 'renders page title';
like $html, qr/<h1>Training Perl Home<\/h1>/, 'renders heading';
like $html, qr/Perl練習環境のCGIホーム画面/, 'renders subheading';
like $html, qr/>CGI</, 'renders CGI mode';

done_testing;
