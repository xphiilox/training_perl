use strict;
use warnings;
use utf8;
use Test::More;

require './app.pl';

my $html = render_home();

like $html, qr/<title>Training Perl Home<\/title>/, 'renders page title';
like $html, qr/<h1>Training Perl Home<\/h1>/, 'renders heading';
like $html, qr/Perl練習環境のホーム画面/, 'renders subheading';
like $html, qr/Plain Perl/, 'does not depend on a web framework';

done_testing;
