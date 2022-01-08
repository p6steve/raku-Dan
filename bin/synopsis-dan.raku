#!/usr/bin/env raku
use lib '../lib';
use Dan;

#SYNOPSIS

#viz. https://pandas.pydata.org/docs/user_guide/10min.html
#viz. https://pandas.pydata.org/docs/user_guide/dsintro.html#dsintro

#s = pd.Series([1, 3, 5, np.nan, 6, 8])

#my $a = Array.new( [1, 3, 5, NaN, 6, 8] );     #say $a[2];

my $s1 = Series.new(
            data => [1, 3, 5, NaN, 6, 8],
            #index => Nil,
            #dtype => Nil,
            #name => Nil,
            #copy => Nil,
        );

say ~$s1;
say $s1.data;
say $s1.index;
say $s1.index{2};


#s = pd.Series(np.random.randn(5), index=["a", "b", "c", "d", "e"])

my $s2 = Series.new(
            data => [rand xx 5],
            index => <a b c d e>,
            #dtype => Nil,
            #name => Nil,
            #copy => Nil,
        );

say ~$s2;
say $s2.data;
say $s2.index;
say $s2.index<c>;




#`[
#]
