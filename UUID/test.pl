use lib::uuid;

my $uuid = lib::uuid->new;

print $uuid->create_hex;