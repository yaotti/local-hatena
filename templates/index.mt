<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta http-equiv="Content-Style-Type" content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<title>Local Hatena</title>
<style>
.main {
margin: 0 auto;
width: 900px;
}
</style>
</head>
<body>
<h1>Local Hatena Diary</h1>
<div class="main">
<? for my $y (reverse sort keys %$entries) { ?>
    <h2><?= $y ?></h2>
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
</body>
</html>
