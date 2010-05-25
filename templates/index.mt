<? extends '_base' ?>
? block main => sub {
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
    <li><a href="<?= sprintf "/keyword?group=%s&name=%s", $group, $keyword?>"><?= $keyword ?></a></li>
    <? } ?>
  </ul>
  <? } ?>
</div>
? }
