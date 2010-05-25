<? extends '_base' ?>
? block main => sub {
<? for my $e (@$entries) { ?>
  <h2 class="entry-type"><?= $e->{name} ?></h2>
  <?= $e->{body} ?>
  <? } ?>
? }
