package Algorithm::SocialNetwork;
use Spiffy -Base;
our $VERSION = '0.01_01';

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

__END__

=head1 NAME

  Algorithm::SocialNetwork - Social Network Analysis

=head1 SYNOPSIS

    use Graph::Undirected;
    use Algorithm::SocialNetwork;

    my $G = Graph::Undirected->new();
    $G->add_edges([qw(a b)], [qw(b c)]);
    my $algo = Algorithm::SocialNetwork->new(graph => $G3);
    my $BC = $algo->BetweenessCentrality();
    # $BC->{a} is 0
    # $BC->{b} is 2
    # $BC->{c} is 0

=head1 DESCRIPTION

So far this module implement the algorithm provided in [1].
More handy algorithm would be included in the future.
Please consult SYNOPSIS for B<all> of it's usage.

=head1 SEE ALSO

    [1] Ulrik Brandes,
    A Faster Algorithm for Betweenness Centrality,
    http://www.inf.uni-konstanz.de/algo/publications/b-fabc-01.pdf

=head1 COPYRIGHT

Copyright 2004 by Kang-min Liu <gugod@gugod.org>.

This program is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

See <http://www.perl.com/perl/misc/Artistic.html>

=cut

