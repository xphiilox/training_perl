#!/usr/bin/env perl
use strict;
use warnings;
use utf8;
use feature qw(say);
use Encode ();
use IO::Socket::INET;

sub html_escape {
    my ($value) = @_;

    $value =~ s/&/&amp;/g;
    $value =~ s/</&lt;/g;
    $value =~ s/>/&gt;/g;
    $value =~ s/"/&quot;/g;
    $value =~ s/'/&#39;/g;

    return $value;
}

sub render_home {
    my @stats = (
        {label => 'Scripts', value => '3', note => 'Ready to run'},
        {label => 'Tests', value => '2', note => 'Passing target'},
        {label => 'Examples', value => '4', note => 'Perl basics'},
        {label => 'Web App', value => '1', note => 'Plain Perl'},
    );

    my @tasks = (
        {name => 'hello.pl を実行する', state => '完了', time => 'Step 1'},
        {name => 'テストを追加する', state => '準備中', time => 'Step 2'},
        {name => 'Webページを育てる', state => '次にやる', time => 'Step 3'},
    );

    my $stat_cards = join "\n", map {
        sprintf <<'HTML', map { html_escape($_) } @$_{qw(label value note)};
        <article class="card">
          <div class="label">%s</div>
          <div class="value">%s</div>
          <div class="note">%s</div>
        </article>
HTML
    } @stats;

    my $task_rows = join "\n", map {
        my $class = $_->{state} eq '完了' ? 'ok' : $_->{state} eq '次にやる' ? 'warn' : '';
        sprintf <<'HTML', html_escape($_->{name}), html_escape($class), html_escape($_->{state}), html_escape($_->{time});
            <tr>
              <td>%s</td>
              <td><span class="badge %s">%s</span></td>
              <td>%s</td>
            </tr>
HTML
    } @tasks;

    return <<"HTML";
<!doctype html>
<html lang="ja">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Training Perl Home</title>
  <style>
    :root {
      color-scheme: light;
      --bg: #f5f7fb;
      --panel: #ffffff;
      --line: #d9e0ea;
      --text: #172033;
      --muted: #667085;
      --primary: #1267d8;
      --ok: #138a43;
      --warn: #b15c00;
    }

    * {
      box-sizing: border-box;
    }

    body {
      margin: 0;
      background: var(--bg);
      color: var(--text);
      font-family: system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
    }

    header {
      background: var(--panel);
      border-bottom: 1px solid var(--line);
      padding: 20px 28px;
    }

    main {
      max-width: 1120px;
      margin: 0 auto;
      padding: 28px;
    }

    h1 {
      margin: 0;
      font-size: 24px;
      letter-spacing: 0;
    }

    h2 {
      margin: 0 0 14px;
      font-size: 18px;
    }

    .subhead {
      margin: 6px 0 0;
      color: var(--muted);
    }

    .grid {
      display: grid;
      grid-template-columns: repeat(4, minmax(0, 1fr));
      gap: 14px;
      margin-bottom: 24px;
    }

    .card,
    .panel {
      background: var(--panel);
      border: 1px solid var(--line);
      border-radius: 8px;
    }

    .card {
      padding: 16px;
    }

    .label {
      color: var(--muted);
      font-size: 13px;
    }

    .value {
      margin-top: 8px;
      font-size: 28px;
      font-weight: 700;
    }

    .note {
      margin-top: 6px;
      color: var(--primary);
      font-size: 13px;
    }

    .panel {
      padding: 18px;
      margin-bottom: 24px;
    }

    table {
      width: 100%;
      border-collapse: collapse;
    }

    th,
    td {
      padding: 12px 10px;
      border-top: 1px solid var(--line);
      text-align: left;
      font-size: 14px;
    }

    th {
      color: var(--muted);
      font-weight: 600;
    }

    .badge {
      display: inline-block;
      border-radius: 999px;
      padding: 4px 9px;
      background: #eef4ff;
      color: var(--primary);
      font-size: 12px;
      font-weight: 600;
    }

    .badge.ok {
      background: #eaf8ef;
      color: var(--ok);
    }

    .badge.warn {
      background: #fff4e5;
      color: var(--warn);
    }

    .actions {
      display: flex;
      gap: 10px;
      flex-wrap: wrap;
    }

    button {
      border: 1px solid var(--line);
      border-radius: 6px;
      background: var(--panel);
      color: var(--text);
      padding: 10px 14px;
      font: inherit;
    }

    button.primary {
      border-color: var(--primary);
      background: var(--primary);
      color: #ffffff;
    }

    \@media (max-width: 820px) {
      .grid {
        grid-template-columns: repeat(2, minmax(0, 1fr));
      }
    }

    \@media (max-width: 520px) {
      header,
      main {
        padding: 18px;
      }

      .grid {
        grid-template-columns: 1fr;
      }
    }
  </style>
</head>
<body>
  <header>
    <h1>Training Perl Home</h1>
    <p class="subhead">Perl練習環境のホーム画面</p>
  </header>

  <main>
    <section class="grid" aria-label="summary">
$stat_cards
    </section>

    <section class="panel">
      <h2>Learning Tasks</h2>
      <table>
        <thead>
          <tr>
            <th>項目</th>
            <th>状態</th>
            <th>目安</th>
          </tr>
        </thead>
        <tbody>
$task_rows
        </tbody>
      </table>
    </section>

    <section class="panel">
      <h2>Quick Actions</h2>
      <div class="actions">
        <button class="primary">サンプル実行</button>
        <button>テスト確認</button>
        <button>コードを書く</button>
        <button>デバッグする</button>
      </div>
    </section>
  </main>
</body>
</html>
HTML
}

sub response {
    my ($status, $content_type, $body) = @_;

    my $length = length Encode::encode('UTF-8', $body);

    return join "\r\n",
        "HTTP/1.1 $status",
        "Content-Type: $content_type; charset=utf-8",
        "Content-Length: $length",
        "Connection: close",
        "",
        $body;
}

sub run_server {
    my ($host, $port) = @_;

    my $server = IO::Socket::INET->new(
        LocalAddr => $host,
        LocalPort => $port,
        Proto     => 'tcp',
        Listen    => 10,
        ReuseAddr => 1,
    ) or die "Cannot start server on $host:$port: $!";

    say "Web application available at http://$host:$port";

    while (my $client = $server->accept) {
        my $request = <$client> // '';
        my ($method, $path) = split /\s+/, $request;

        my $line;
        while (defined($line = <$client>) && $line ne "\r\n") {
        }

        my $body = $method && $method eq 'GET' && $path && $path eq '/'
            ? response('200 OK', 'text/html', render_home())
            : response('404 Not Found', 'text/plain', "Not Found\n");

        print {$client} Encode::encode('UTF-8', $body);
        close $client;
    }
}

run_server('0.0.0.0', 3000) unless caller;

1;
