<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta http-equiv="Content-Style-Type" content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<title>Local Hatena</title>
<style>
body {
background: #DEE3E6;
}
.main {
margin: 0 auto;
width: 900px;
}
.entries {
width: 400px;
float: left;
}
.keywords {
width: 400px;
float: right;
}

</style>
</head>
<body>
<h1>Local Hatena Diary</h1>
<div class="main">
  <div class="entries">
    <h2>Group/Diary Entries</h2>
<? for my $y (reverse sort keys %$entries) { ?>
    <h3><?= $y ?></h3>
    <ul>
    <? for my $m (reverse sort keys %{$entries->{$y}}) { ?>
      <li><a href="<?= sprintf "/%s/%s", $y, $m ?>"><?= $m ?></a></li>
      <ul>
       <? for my $d (reverse sort keys %{$entries->{$y}->{$m}}) { ?>
         <li><a href="<?= sprintf "/%s/%s/%s", $y, $m, $d ?>"><?= $d ?>@<?= join ', ', @{$entries->{$y}->{$m}->{$d}} ?></a></li>
       <? } ?>
       </ul>
    <? } ?>
    </ul>
<? } ?>
  </div>
  <div class="keywords">
    <h2>Group Keywords</h2>
  <? for my $group (sort keys %$keywords) { ?>
    <h3><?= $group ?></h3>
    <ul>
    <? for my $keyword (sort @{$keywords->{$group}}) { ?>
      <li><a href="<?= sprintf "/%s/%s", $group, $keyword?>"><?= $keyword ?></a></li>
    <? } ?>
    </ul>
  <? } ?>
  </div>
</div>
</body>
</html>
