use inc::Module::Install;

name            ('Algorithm-SocialNetwork');
abstract        ('Social Network Analysis');
author          ('Kang-min Liu <gugod@gugod.org>');
license         ('perl');
version_from    ('lib/Algorithm/SocialNetwork.pm');
requires        ('Spiffy');
requires        ('Graph' => 0.54);
build_requires  ('Test::More');

&WriteAll;

