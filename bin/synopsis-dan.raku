#!/usr/bin/env raku
use lib '../lib';
use Dan;

#SYNOPSIS

#viz. https://pandas.pydata.org/docs/user_guide/10min.html
#viz. https://pandas.pydata.org/docs/user_guide/dsintro.html#dsintro

### DataSlice ###

# used for the row (or column) of a DataFrame

#`[
my $ds = DataSlice.new( data => [1, 3, 5, NaN, 6, 8], index => <a b c d e f>, name => 'john' );
dd $ds;
say $ds.index;
say $ds.data;
say ~$ds;

say $ds[1];
say $ds[0..2];
say $ds[*];

say $ds{'b'};
say $ds<b d>;
say "=============================================";
#]

### Series ###

my \s = $;    

#`[
#s = pd.Series([1, 3, 5, np.nan, 6, 8])
#s = Series.new([1, 3, 5, NaN, 6, 8]);                                   
s = Series.new([1, 3, 5, NaN, 6, 8], name => "mary");                                   
#s = Series.new(data => [1, 3, 5, NaN, 6, 8], name => "mary");                                   
#s.name = "john";

say ~s; say "=============================================";
#]

#s = pd.Series(np.random.randn(5), index=["a", "b", "c", "d", "e"])
s = Series.new([rand xx 5], index => <a b c d e>);

say s.index;
say ~s; say "=============================================";

#`[
#s = pd.Series({"b": 1, "a": 0, "c": 2})

#canonical form is (ordered) Array of Pairs
s = Series.new([b=>1, a=>0, c=>2]);

#or coerce an (unordered) Hash to an Array
#my %h = %(b=>1, a=>0, c=>2); 
#s = Series.new(%h.Array);

say ~s; say "=============================================";

#s = pd.Series(5.0, index=["a", "b", "c", "d", "e"])
s = Series.new(5e0, index => <a b c d e>);

say ~s; say "=============================================";

say s[1];
say s{"c"};
say s<c>;
say s.data;
say s.index.sort(*.value).map(*.key);
say s.of;
say s.dtype;
#]

### Datatypes ###

#`[
The pandas / python base numeric datatypes map as follows:

- float             Num 
- int               Int
- bool              Bool

... TBD (check precision)
- timedelta64[ns]   Duration
- datetime64[ns]    Instance

... representation in pandas
- float             Real
- float             Rat

pandas ExtensionTypes are TBD
string / object dtypes are TBD

The general approach is:
- raku only - everything is Mu and works as usual
... is this efficient?
... do we care?
... how to handle (eg.) Measure types?
- raku2pandas - map dtypes suitably
... maybe remember original types on round trip (name, label?)
- pandas2raku - map dtypes suitably
... remember original type on round trip

So, functions are:
- Dan ... dtype is a courtesy attr, does nothing
#]

#`[
### Series Operations ###

# Array Index Slices
say s[*-1];
say s[0..2];
say s[2] + 2;

# Math
say s.map(*+2);
say [+] s;

# Hyper
dd s.hyper;
say s >>+>> 2;
say s >>+<< s;
my \t = s; say ~t;
#]

### DataFrames ###

#`[
dates = pd.date_range("20130101", periods=6)

DatetimeIndex(['2013-01-01', '2013-01-02', '2013-01-03', '2013-01-04',
               '2013-01-05', '2013-01-06'],
              dtype='datetime64[ns]', freq='D')

df = pd.DataFrame(np.random.randn(6, 4), index=dates, columns=list("ABCD"))
#]

my \dates = (Date.new("2022-01-01"), *+1 ... *)[^6];    #say dates;

#my \df = DataFrame.new( [[rand xx 4] xx 6] );
#my \df = DataFrame.new( [[rand xx 4] xx 6], index => dates);
my \df = DataFrame.new( [[rand xx 4] xx 6], index => dates, columns => <A B C D> );

say ~df;
say "---------------------------------------------";

#say df.data;
say df.index;
say df.columns;
say "=============================================";

#`[
# Positional Access
say df.elems;
say ~df[0;1];
say ~df[*;1];
say ~df[0;*];
say ~df[2];
say ~df[0,3];
say ~df[0..1];
say ~df[*];
say ~df[0][1];
say ~df[*][1];
say ~df[0][*];
say ~df[0..1];
say ~df[0..*-3];
say ~df[0..*-3][1];
say ~df[0..*-3][0..*-2];
say df[0..1];
say df[0..1].^name;
say ~df[0..1][1];
say ~df[0..1][*];
say ~df[0]^;
say ~df[0..1]^;
say ~df[*][1];
say ~df[0..1][1];
say ~df[0..*-2][1];
say ~df[0..1][0];
say ~df[0..1][1,2];
say ~df[0..*-2][1..*-1];
say ~df[0..1][*];
say "=============================================";
#]

#`[
# Associative Access
say dates[0..1];
say ~df{dates[0]}; 
say ~df{dates[0..1]}^; 
say ~df{dates[0]}{'C'}; 
say ~df{dates[0]}<D>; 
say ~df{dates[0..1]}<A>; 
say ~df[*]<A C>;
say ~df.series: <C>;
say "=============================================";
#]

#`[
df2 = pd.DataFrame(
   ...:     {
   ...:         "A": 1.0,
   ...:         "B": pd.Timestamp("20130102"),
   ...:         "C": pd.Series(1, index=list(range(4)), dtype="float32"),
   ...:         "D": np.array([3] * 4, dtype="int32"),
   ...:         "E": pd.Categorical(["test", "train", "test", "train"]),
   ...:         "F": "foo",
   ...:     }
   ...: )

#]
my \df2 = DataFrame.new([
        A => 1.0,
        B => Date.new("2022-01-01"),
        C => Series.new(1, index => [0..^4], dtype => Num),
        D => [3 xx 4],
        E => Categorical.new(<test train test train>),
        F => "foo",
]);

#`[
say ~df2; 
say "---------------------------------------------";

say df2.data;
say df2.index;
say df2.columns;
say df2.dtypes;
say "=============================================";
#]

#[
### DataFrame Operations ###

# Math
say df.map(*.map(*+2));
say df[1].map(*+3);
say df[1][1,2].map(*+3);
say [+] df[1;*];
say [+] df[*;1];
say [+] df[*;*];   #wow
say [Z] @ = df;    #wow
say [Z] df.data;   #wow
say ~df.T;
say ~DataFrame.new( data => ([Z] df.data), index => df.columns, columns => df.index );

# Hyper
dd df.hyper;
say df >>+>> 2;
say df >>+<< df;
my \dg = df; say ~dg;

# Head & Tail
say ~df[0..^3]^;                # head
say ~df[(*-3..*-1)]^;           # tail

# Describe
say ~df[*]<A>.describe;
say ~df.describe;

# Sort
#viz. https://docs.raku.org/routine/sort#(List)_routine_sort

say ~df.sort: { .[1] };         # sort by 2nd col (ascending)
say ~df.sort: { .[1], .[2] };   # sort by 2nd col, then 3rd col (and so on)
say ~df.sort: { -.[1] };        # sort by 2nd col (descending)
say ~df.sort: { df[$++]<C> };   # sort by col C
say ~df.sort: { df.ix[$++] };   # sort by index  (cx for cols)
say ~df.sort: { df.ix.reverse.[$++] };   # sort by index (descending)

# Grep MOVE TO END AS DESTRUCTIVE
say ~df.grep( { $_[1] < 0.5 } ); # grep by 2nd column 
say ~df.grep( { df.ix[$++] eq <2022-01-02 2022-01-06>.any } ); # grep index (multiple) 
#]


#`[
Notes:
- NaN is raku built in
#]

