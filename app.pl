#!/usr/bin/env perl
use strict;
use warnings;
use utf8;
use feature qw(say);

use Mojolicious::Lite -signatures;

app->config(hypnotoad => {listen => ['http://*:3000']});

get '/' => sub ($c) {
    my @stats = (
        {label => 'Scripts', value => '3', note => 'Ready to run'},
        {label => 'Tests', value => '2', note => 'Passing target'},
        {label => 'Examples', value => '4', note => 'Perl basics'},
        {label => 'Web App', value => '1', note => 'Mojolicious'},
    );

    my @tasks = (
        {name => 'hello.pl を実行する', state => '完了', time => 'Step 1'},
        {name => 'テストを追加する', state => '準備中', time => 'Step 2'},
        {name => 'Webページを育てる', state => '次にやる', time => 'Step 3'},
    );

    $c->render(
        template => 'index',
        stats    => \@stats,
        tasks    => \@tasks,
    );
};

app->start unless caller;
app;

__DATA__

@@ index.html.ep
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

    @media (max-width: 820px) {
      .grid {
        grid-template-columns: repeat(2, minmax(0, 1fr));
      }
    }

    @media (max-width: 520px) {
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
      % for my $stat (@$stats) {
        <article class="card">
          <div class="label"><%= $stat->{label} %></div>
          <div class="value"><%= $stat->{value} %></div>
          <div class="note"><%= $stat->{note} %></div>
        </article>
      % }
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
          % for my $task (@$tasks) {
            % my $class = $task->{state} eq '完了' ? 'ok' : $task->{state} eq '次にやる' ? 'warn' : '';
            <tr>
              <td><%= $task->{name} %></td>
              <td><span class="badge <%= $class %>"><%= $task->{state} %></span></td>
              <td><%= $task->{time} %></td>
            </tr>
          % }
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
