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

.entry-type {
background-color: #D2D2D2;
padding: 0px 10px;
}
</style>
</head>
<body>
<h1>Local Hatena Diary</h1>
<div class="main">
<? for my $group (reverse sort keys %$keywords) { ?>
    <h2>Keyword@<?= $group ?></h3>
      <? for my $k (@{$keywords->{$group}}) { ?>
         <h3><?= $k->{name}?></h3>
         <?= $k->{body} ?>
      <? } ?>
  <? } ?>
</div>
</body>
</html>
