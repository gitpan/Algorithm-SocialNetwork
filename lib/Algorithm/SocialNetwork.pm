package Algorithm::SocialNetwork;
use Spiffy -Base;
our $VERSION = '0.02';

field graph => {},
    -init => 'Graph->new()';

### negative value doesn't make sense for Bc
### Un-normlized result.
sub BetweenessCentrality {
    my @V  = $self->graph->vertices;
    my %CB; @CB{@V}=map{0}@V;
    for my $s (@V) {
        my (@S,$P,%sigma,%d,@Q);
        $P->{$_} = [] for (@V);
        @sigma{@V} = map{0}@V; $sigma{$s} = 1;
        @d{@V} = map{-1}@V; $d{$s} = 0;
        push @Q,$s;
        while(@Q) {
            my $v = shift @Q;
            push @S,$v;
            for my $w ($self->graph->neighbors($v)) {
                if($d{$w} < 0) {
                    push @Q,$w;
                    $d{$w} = $d{$v} + 1;
                }
                if($d{$w} == $d{$v} + 1) {
                    $sigma{$w} += $sigma{$v};
                    push @{$P->{$w}},$v;
                }
            }
        }
        my %rho; $rho{$_} = 0 for(@V);
        while(@S) {
            my $w = pop @S;
            for my $v (@{$P->{$w}}) {
                $rho{$v} += ($sigma{$v}/$sigma{$w})*(1+$rho{$w});
            }
            $CB{$w} += $rho{$w} unless $w eq $s;
        }
    }
    return $CB{$_} for(@_);
    return @_? @CB{@_} : \%CB;
}
