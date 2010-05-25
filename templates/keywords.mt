<? extends '_base' ?>
? block main => sub {
<? for my $group (reverse sort keys %$keywords) { ?>
    <h2>Keyword@<?= $group ?></h3>
      <? for my $k (@{$keywords->{$group}}) { ?>
         <h3><?= $k->{name}?></h3>
         <?= $k->{body} ?>
      <? } ?>
  <? } ?>
? }
