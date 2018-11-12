#!/usr/bin/perl
###############################################################################
## \file EnumGen.pl
## \brief Small source code generator for C++
## \author dresden.tsd.automotive.phone@preh.de
##
## Copyright (c) 2016  Preh Car Connect GmbH
## CONFIDENTIAL
###############################################################################

use strict;
use warnings;
use integer;

use File::Find::Rule;
use File::Basename;
use File::Spec;

our $Scriptname = basename($0);
our $Authormail = 'dresden.tsd.automotive.phone@preh.de';
our $Version    = '27';
our $ShowValues = 1; # do not set value when you want to hide enumeration values in STDOUT

our $Helpmessage = <<END;
Version of $Scriptname is: $Version
Synopsis:
\\> $Scriptname <inputfile> [outputpath]
inputfile    Enumeration description file
outputpath   Path for the generated source code file. If not set the source
             code file will be created in working directory.

Format of inputfile:
enum name::space::path::EnumName
Value1, "StringOfValue1"
Value2, "StringOfValue2"

The string of an enumeration value is optional but you have to either skip all
or nothing.
Note that the following author will be default set in the generated source code:
$Authormail
END

sub splitStringToSubStr
{
   my $descLen = 0;
   my $line = $_[0];
   my @arrayString;
   my $str = "";
   while (length(substr($line, $descLen)) > 110 )
   {
      my $count = 0;
      while (not (substr($line, $descLen +110+ $count) =~ /^\s(.*)$/))
      {
         if (++$count > 20)
         {
            last;
         }
      }
      $str = substr($line, $descLen, 110 + $count);
      if (not($str =~ /^\s*$/))
      {
         push @arrayString, $str;
      }
      $descLen  = $descLen + 110 + ($count >= 20 ?  $count:$count+1 );
   }
   $str = substr($line, $descLen);
   if (not($str =~ /^\s*$/))
   {
      push @arrayString,$str   ;
   }
   return  @arrayString;
}


# parse the input file and determine the namespaces, enumeration name, enum values and enum strings
# return an array that contains ref to namespaces and enum name, ref to enum values and ref to enum strings
sub readEnumDescription
{
   my ($filename) = @_;
   open(FILE, $filename) || die ("unable to read file $filename");
   my @namespaces;
   my $type = "";
   my $settings = "";
   my @enumDescription;
   my $line = <FILE>;

   while (not eof(FILE))
   {
      # if empty line or comment - > then next line
      if ($line =~ /^$/ || $line =~ /^\s*\#.*$/)
      {
         $line = <FILE>;
         next;
      }
      # read namespace line
      elsif ($line =~ /^enum\s+(\w(\w|:)+)$/)
      {
         @namespaces = split('::', $1);
         $line = <FILE>;
         next;
      }
      # read type line is optional
      elsif ($line=~/^type\s*(\w*)\s*$/)
      {
         $type = uc($1);
         $line = <FILE>;
         next;
      }
      # read description line
      elsif ($line=~/^description\s+(.*)$/)
      {
         my @arrayString = splitStringToSubStr($1);
         if (@arrayString)
         {
            push @enumDescription, splitStringToSubStr($1);
         }
         $line = <FILE>;
         while (not (eof(FILE) || $line =~ /^((type|enum|author|settings).+)$/))
         {
            push @enumDescription, splitStringToSubStr($line);
            $line = <FILE>;
         }
         next;
      }
      # read authorname is optional
      elsif ($line=~/^author\s+(\w.+)$/)
      {
         my $help = $1;
         if ($help =~/\w+\.\w+\@\w+\.de/)
         {
            $Authormail = $help;
         }
         else
         {
            print "unknown format of authors email address! use default email address: $Authormail\n";
         }
         $line = <FILE>;
         next;
      }
      # kind of settings of the single enum vales, this is not optional, if no kind then generation will be inturrupted
      elsif ($line=~/^settings\s+(\w+)\s*$/)
      {
         $settings = uc($1);
         last;
      }
      # unknown format of line
      else
      {
         die "unable to parser line : $line";
      }
   }
   if (not @namespaces)
   {
      die "Unable to find 'enum' tag in first line of enumeration declaration";
   }

   if (not @enumDescription)
   {
      die "Unable to find 'description' tag in enumeration declaration";
   }

   if ($settings eq "")
   {
      die "Unable to find settings - 'kind' of input method of enumeration declaration";
   }
   my $isBitSet = 0;

   # do nothing if type not defined generate type = flag
   if ($type ne "")
   {
      if ($type eq "BITSET")
      {
         $isBitSet = 1;
      }
      elsif ($type eq "FLAG")
      {
         # do nothing is default type
      }
      else
      {
         die "UNSUPPORTED type $type";
      }
   }
   # read the different enum entries with names, values, strings, comments
   my @names;
   my @values;
   my @strings;
   my @comments;
   my $number = 0;
   my $maxLenName = 0;
   my $maxLenValue = 0;
   my $maxValue = -1;
   my $isDoubleValues = ($settings eq "DOUBLEVALUESTRINGS" || $settings eq "DOUBLEVALUES")  ? 1 : 0;

   die " Settings $settings is only for FLAG allowed but type = $type" if ($isDoubleValues && $isBitSet);

   my $isHex = 0;
   while (my $line = <FILE>)
   {
   # if not: empty line or comment
      if (not ($line =~ /^$/ || $line =~ /^\s*\#.*$/))
      {
         if ($settings eq "NAMES")
         {
            if ($line=~/^([a-zA-Z]\w*)\s*,?\s*(\/\/\/<.+)$/)
            {
               push @names, $1;
               push @values, $number;
               push @strings, $1;
               push @comments, $2;
            }
            else
            {
               die "Settings = \"names\" does not match entry number = $number: $line";
            }
         }
         elsif ($settings eq "VALUES" || $settings eq "DOUBLEVALUES")
         {
            if ($line=~/^([a-zA-Z]\w*)\s*,?\s+((0x)?[0-9a-fA-F]+)\s*,?\s*(\/\/\/<.+)$/)
            {
               my $isNewHex = defined($3) ? ($3 eq "0x") : 0;
               if ($number ne 0)
               {
                  die (" all values in Hex or all in decimal do not change from line to line " ) if ($isHex ne $isNewHex);
               }
               $isHex = $isNewHex;
               push @names, $1;
               push @values, $2;
               push @strings, $1;
               push @comments, $4;
            }
            else
            {
               die "Settings = \"values\" does not match entry number = $number: $line";
            }
         }
         elsif ($settings eq "STRINGS")
         {
            if ($line=~/^([a-zA-Z]\w*)\s*,?\s+"([0-9a-zA-Z\.\-\+\_]+)"\s*,?\s*(\/\/\/<.+)$/)
            {
               push @names, $1;
               push @values, $number;
               push @strings, $2;
               push @comments, $3;
            }
            else
            {
               die "Settings = \"strings\" does not match entry number = $number: $line";
            }
         }
         elsif ($settings eq "VALUESTRINGS" || $settings eq "DOUBLEVALUESTRINGS" )
         {
            if ($line=~/^([a-zA-Z]\w*)\s*,?\s+((0x)?[0-9a-fA-F]+)\s*,?\s+"([0-9a-zA-Z\.\-\+\_]+)"\s*,?\s*(\/\/\/<.+)$/)
            {
               my $isNewHex = defined($3) ? ($3 eq "0x") : 0;
               if ($number ne 0)
               {
                  die (" all values in Hex or all in decimal do not change from line to line " ) if ($isHex ne $isNewHex);
               }
               $isHex = $isNewHex;
               push @names, $1;
               push @values, $2;
               push @strings, $4;
               push @comments, $5;
            }
            else
            {
               die "Settings = \"values\" does not match entry number = $number: $line";
            }
         }
         else
         {
             die "unsupported Settings: $settings";
         }
         # consistency checks
         my @help = @names;
         my $lastValue = $values[$#values];
         if ($isHex)
         {
            $lastValue = hex($lastValue);
         }
         die (" value is not a valid number neither in hex nor decimal, maybe you forgot \"0x\"?\n") if ($lastValue ne int($lastValue));
         my $lastName  = pop @help;
         if ($lastName ~~ @help)
         {
            die "$lastName is used twice as enum value name";
         }
         if ( not ($settings eq "DOUBLEVALUESTRINGS" || $settings eq "DOUBLEVALUES"))
         {
            if ($lastValue <= $maxValue)
            {
               die "@names @values : the values to names must be sorted ascendingly by value!";
            }
            $maxValue = $lastValue;
         }
         if ($maxLenName < length($names[$#names]))
         {
             $maxLenName = length($names[$#names]);
         }
         if ($maxLenValue < length($lastValue))
         {
             $maxLenValue = length($lastValue);
         }
         $number++;
      }
   }
   close(FILE);

   if (not @values)
   {
     die "no values could be found: either settings is unsupported or ??";
   }
# comment to debug! die "($isContinuousEnum ? "cont": "sparse"). "$type \n@namespaces \n$isBitSet\n$isLargeBitSet\n@enumDescription\n@names\n@values\n@strings\n@comments\n$number\n$maxLenName\n$maxLenValue; ";

#   die "No namespace found" unless (@namespaces);
   my @results;
   push @results, \@namespaces;
   push @results, \$isBitSet;
   push @results, \@enumDescription;
   push @results, \@names;
   push @results, \@values;
   push @results, \@strings;
   push @results, \@comments;
   push @results, \$number;
   push @results, \$maxLenName;
   push @results, \$maxLenValue;
   push @results, \$isDoubleValues;
   push @results, \$maxValue;
   return @results;
}

sub toStringFlag
{
   my $enumName = $_[0];
   my $enumToString = $_[1];
   my $retValtoStringFlag = <<END;
   /// \@brief returns a const reference to a string representing that the value is not part of the enum
   const std::string unknown = "UNKNOWN";

   /// \@brief returns a const reference to the corresponding string representing given enum value
   /// \@param[in] value - that should be printed
   /// \@return const reference to corresponding string
   inline const std::string& toString(const $enumName\::E value)
   {
      switch ( value )
      {
$enumToString
      }
      return $enumName\::unknown;
   }
END

   return $retValtoStringFlag;
}

sub toStringDoubles
{
   my $enumName = $_[0];
   my $enumToString = $_[1];
   my $retValtoStringDoubles = <<END;
   /// \@brief Returns a string of all strings corresponding the value
   /// \@param[in] value - that should be printed
   /// \@return string
   inline const std::string toString(const $enumName\::E value)
   {
      std::string ret;
$enumToString
      if(ret.empty())
      {
         ret.append("UNKNOWN");
      }
      return ret;
   }
END

   return $retValtoStringDoubles;
}


sub toParseString
{
   my $enumName = $_[0];
   my $stringToEnum = $_[1];
   my $defaultValue = $_[2];
   my $retVal = <<END;
   /// \@brief Returns to a given string the enumeration value if it matches with an EString
   ///        If no match, $defaultValue is returned
   ///        NOTICE that that function returns uint32_t it is up to the user to check
   ///        whether it is allowed enumeration value
   /// \@param[in] string - that should be parsed
   /// \@return enum value
   inline uint32_t parseFromString(const std::string& value)
   {
$stringToEnum
      return static_cast<uint32_t>($defaultValue);
   }

END

   return $retVal;
}

sub toStringBitset
{
   my $enumName = $_[0];
   my $enumToString = $_[1];
   my $retValtoStringBitset = <<END;
   /// \@brief returns a string of all strings corresponding to a set bit in value
   /// \@param[in] value - that should be printed
   /// \@return string
   inline const std::string toString(const $enumName\::B value)
   {
      std::string ret;
      if      (NOVALUE == value) {ret.append("NOVALUE");}
      else if (ALL     == value) {ret.append("ALL");}
      else
      {
$enumToString
      }
      if(ret.empty())
      {
         ret.append("UNKNOWN");
      }
      return ret;
   }
END

   return $retValtoStringBitset;
}

sub operatorOverload
{
   my $enumName = $_[0];
   my $allValues = $_[1];
   my $bitCounter = $_[2];
   my $retValoperatorOverload = <<END;
   /// \@brief $enumName\::B constant, if no bit is set
   const $enumName\::B NOVALUE = static_cast <$enumName\::B>(0);

   /// \@brief overload operator| for $enumName\::B
   ///        This functions returns $enumName\::B, where all bits are set that are set in lhs or rhs.
   /// \@param[in] lhs of |
   /// \@param[in] rhs of |
   /// \@return rhs | lhs
   inline $enumName\::B operator|(const $enumName\::B lhs, const $enumName\::B rhs)
   {
      return static_cast< $enumName\::B >(+lhs | +rhs);
   }

   /// \@brief $enumName\::B constant, if all available bits are set
$allValues
   /// \@brief overload operator& for enum $enumName\::B
   ///        This functions returns a $enumName\::B, where only the bits are set which are set in lhs and rhs.
   /// \@param[in] lhs of &
   /// \@param[in] rhs of &
   /// \@return rhs & lhs
   inline $enumName\::B operator&(const $enumName\::B lhs, const $enumName\::B rhs)
   {
      return static_cast< $enumName\::B >(+lhs & +rhs);
   }

   /// \@brief returns to a given bitset value the number of set bits
   /// \@param[in] value - the bitset for which the bits shall be counted
   /// \@return number of set bits
   inline std::size_t bitCount($enumName\::B value)
   {
      std::size_t retVal =0;

$bitCounter
      return retVal;
   }

   /// \@brief overload operator~ for $enumName\::B.
   ///        This function reverse all bits.
   /// \@param[in] a - to be reversed.
   /// \@return negation of a
   inline $enumName\::B operator~(const $enumName\::B a)
   {
      return static_cast< $enumName\::B >(ALL ^ a);
   }

   /// \@brief introduce operator- for bitsets; the meaning is as follows:
   ///         value1 - value2 = value1 &~ value2
   ///  all bits in value1 will be set to zero, if they are set in value2.
   /// \@param[in] lhs of -
   /// \@param[in] rhs of -
   /// \@return lhs - rhs
   inline $enumName\::B operator-(const $enumName\::B lhs, const $enumName\::B rhs)
   {
      return (lhs & ~ rhs);
   }
END

   return $retValoperatorOverload;
}
# if an out file exists look for the year of creation
sub parseOutputfileYear
{
   my ($filename) = @_;

   my $foundYear;
   if (-r $filename)
   {
      open(FILE, $filename) || die ("unable to read file $filename");
      while (my $line = <FILE>)
      {
         if ($line=~/\/\/!\s*Copyright\s*\(c\)\s*(\d+)/)
         {
            $foundYear = $1;
            last;
         }
      }
      close(FILE);
   }
   return $foundYear;
}

sub createEnum
{
   my ($filename, $outputpath) = @_;

   my @parseResult = readEnumDescription($filename);
   my @namespaces      = @{shift @parseResult};
   my $isBitSet        = ${shift @parseResult};
   my @enumDescription = @{shift @parseResult};
   my @names           = @{shift @parseResult};
   my @values 	        = @{shift @parseResult};
   my @strings         = @{shift @parseResult};
   my @comments        = @{shift @parseResult};
   my $numberEnums     = ${shift @parseResult};
   my $getMaxLenName   = ${shift @parseResult};
   my $getMaxLenValue  = ${shift @parseResult};
   my $isDoubleValues  = ${shift @parseResult};
   my $maxValue        = ${shift @parseResult};

   my $namespaceOpen = "";
   my $namespaceClose = "";
   my $namespaceCloseDesc = "";

   print "\nfound enum: ";
   my $count = 0;
   foreach my $s (@namespaces)
   {
      if ($count gt 0 )
      {
         if ($count lt $#namespaces)
         {
            $namespaceOpen .= "\n";
         }
         print "::";
         $namespaceCloseDesc .= "::";
      }
      if ($count lt $#namespaces)
      {
         $namespaceOpen .= "namespace $s {";
         $namespaceClose .= "} ";
         $namespaceCloseDesc .= "$s";
      }
      print "$s";
      $count++;
   }
   print "\n";
   $namespaceClose .= "// $namespaceCloseDesc";

   # enum name and file names
   my $enumName = $namespaces[$#namespaces];
   my $headerName = "$enumName.hpp";
   

   # doxygen commentar enum
   my $indent = " " x 3;
   chomp(@enumDescription);
   my $enumDescriptionDoxygen = "$indent///\@brief ";
   while( my ($i, $e) = each (@enumDescription))
   {
      $enumDescriptionDoxygen .= $e;
      if ($i ne (@enumDescription-1) )
      {
         $enumDescriptionDoxygen .= "\n$indent///       ";
      }
   }
   print ($enumDescriptionDoxygen . "\n") if (defined $ShowValues);

   my $outfileHeader = $headerName;
   $outfileHeader = File::Spec->catfile($outputpath, $headerName) if ($outputpath);

   # set include guard
   my $includeGuard = "";

   my $flag = 0;
   foreach my $n (@namespaces)
   {
      if ($flag gt 0)
      {
         $includeGuard .= "_";
      }
      $includeGuard .= uc $n;
      $flag = 1;
   }


   my $indent6 = " " x 6; # default indent for C++ projects is 3
   my $indent3 = " " x 3;
   my $indent9 = " " x 9;

   my $firstPartToStringLine = "";
   my $secondpart = "";
   my $thirdpart = "";
   my $lastpart = "";
   if ($isBitSet)
   {
      $firstPartToStringLine .= $indent9 . "if (";
      $secondpart .= " & value)";
      $thirdpart .= "{ret.append(EStrings[";
      $lastpart .= "] + \",\");}";
   }
   elsif ($isDoubleValues)
   {
      $firstPartToStringLine .= $indent6 . "if (";
      $secondpart .= " == value)";
      $thirdpart .= "{ret.append(EStrings[";
      $lastpart .= "] + \",\");}";
   }
   else # flag
   {
      $firstPartToStringLine .= $indent9 . "case ";
      $secondpart .= ":";
      $thirdpart .= "return EStrings[";
      $lastpart .= "];";
   }

   #determine content of enum, enumStrings and enumToString and stringToEnum
   my $enumValues = "";
   my $enumStrings = "";
   my $enumToString = "";
   my $stringToEnum = "";
   my $allValues = $indent3 . "const $enumName\::B ALL = ";
   my $allValuesPreLen = " " x (length($allValues)-2);
   my $bitCounter ="";
   chomp(@names);
   chomp(@comments);
   chomp(@values);
   chomp(@strings);

   while (my ($i, $name) = each(@names))
   {
      my $value = shift @values;
      my $comment = shift @comments;
      my $string =  shift @strings;
      my $indentMaxName = " " x ($getMaxLenName - length($name) + 1);
      $enumStrings .= $indent6. "\"" . $string . "\"";
      $enumToString.= $firstPartToStringLine . $name . $secondpart . $indentMaxName . $thirdpart . $i . $lastpart;
      $allValues .= $enumName . "\::" . $name;
      $enumValues .= "$indent6$name$indentMaxName= ";
      $stringToEnum .= $indent6 ."if (0 == value.compare(\"". $string ."\")) return ". $name .";\n";
      if ($isBitSet)
      {
         $enumValues .= "1 << ";
         $bitCounter .= $indent6."if($enumName\::$name \& value){retVal++;}\n"
      }
      $enumValues .= $value;
      if ($i ne (@names-1))
      {
         $enumToString.= "\n";
         $enumStrings.= ",\n";
         $enumValues .= ",";
         $allValues  .= "\n$allValuesPreLen| ";
      }
      else
      {
         $enumValues .= " ";
         $allValues  .=";\n";
      }
      $enumValues .= " " x ($getMaxLenValue - length($value) + 3);
      $enumValues .= "$comment";
      if ($i ne (@names-1))
      {
         $enumValues .= "\n";
      }
   }
   print ($enumValues . "\n") if (defined $ShowValues);

   #overload bitoperators, if type = Bitset
   my $bitOperatorOverload = "";
   if ($isBitSet)
   {
     $bitOperatorOverload = operatorOverload($enumName , $allValues, $bitCounter);
   }
   #toStringMethod
   my $toStringMethod = "";
   my $stringArrayDescription;
   my $numberDescription;
   my $defaultValue = "";
   my $limits = "";
   if ($isBitSet)
   {
      $stringArrayDescription = "array of strings - containing a string to each enum value representing a bit";
      $numberDescription = "max number of bits that can be set";
      $toStringMethod = toStringBitset($enumName, $enumToString);
      $defaultValue = "$enumName\::NOVALUE";

   }
   elsif ($isDoubleValues)
   {
      $numberDescription = "number of different enum values";
      $stringArrayDescription = "array of strings to each enum value";
      $toStringMethod = toStringDoubles($enumName, $enumToString);
      $defaultValue = $maxValue > $numberEnums ? " numeric_limits<uint32_t>::max() ": " $enumName\::number ";
      $limits =  ($maxValue > $numberEnums) ?"#include <limits>\n" : "";
   }
   else #type flag
   {
      $numberDescription = "number of different enum values";
      $toStringMethod = toStringFlag($enumName, $enumToString);
      $stringArrayDescription = "array of strings to each enum value";
      $defaultValue = ($maxValue - $numberEnums >=0) ? "std::numeric_limits<uint32_t>::max()": "$enumName\::number";
      $limits =  ($maxValue > $numberEnums) ?"#include <limits>\n" : "";
   }
print "\nfound $maxValue: $maxValue $numberEnums";
  my $EorB = ($isBitSet ? "B" : "E");
  my $toParseString = toParseString("$enumName\::$EorB", $stringToEnum, $defaultValue);
  # generate header file content

  my $contentHeader = <<END;
//////////////////////////////////////////////////////////////////////
/// \@file   $headerName
///
/// \@author $Authormail
///
/// \@brief  Enumeration $enumName and helper functions from file: "$filename"
///
/// Generated by $Scriptname version $Version
///
/// Copyright (c) Preh Car Connect GmbH
/// CONFIDENTIAL
//////////////////////////////////////////////////////////////////////

#ifndef $includeGuard\_HPP
#define $includeGuard\_HPP

#include <string>
#include <ostream>
$limits

$namespaceOpen


namespace $enumName
{
$enumDescriptionDoxygen
   enum $EorB
   {
$enumValues
   };

   /// \@brief $stringArrayDescription
   const std::string EStrings[$numberEnums] =
   {
$enumStrings
   };

   /// \@brief $numberDescription
   const std::size_t number = $numberEnums;

$bitOperatorOverload
$toStringMethod
$toParseString
   /// \@brief overload operator<< for $enumName\::$EorB
   ///        This functions enables to log the enumValues by being automatically converted toString
   /// \@param[inout] os - to the output stream the enum value shall be added
   /// \@param[in] value - the value that shall be logged
   /// \@return the reference of the adapted output stream
   inline std::ostream& operator<<(std::ostream& os,
                                   $namespaceCloseDesc$enumName\::$EorB value)
   {
      os << $namespaceCloseDesc$enumName\::toString(value);
      return os;
   }

} // $enumName
$namespaceClose


#endif // $includeGuard\_HPP

END

   # write generated content to file
   open(FILEH, ">$outfileHeader") || die ("unable to open '$outfileHeader' for write");
   print FILEH $contentHeader;
   close FILEH;
}



###############################################
# main
###############################################
if ($#ARGV == 0)
{
  if (-d $ARGV[0])
  {
     my @subdirs = File::Find::Rule->directory->in($ARGV[0]);

     # find all the .Enum files in @subdirs
     my @files = File::Find::Rule->file()
                                 ->name( '*.Enum' )
                                 ->in(  @subdirs );
     print @files . "\n";
     foreach my $file (@files)
     {
        my($fname, $dirs, $suffix) = fileparse($file);
        print "\n acutal file : " . $file . "\n directory = " .$dirs ."\n " ;
        createEnum($file, $dirs);
     }
  }
  else
  {
     die "unable to read input file: '$ARGV[0]'" unless (-r $ARGV[0]);
     createEnum($ARGV[0]);
  }
}
elsif ($#ARGV == 1)
{
  die "unable to read input file: '$ARGV[0]'"             unless (-r $ARGV[0]);
  die "2nd parameter in not a valid directory '$ARGV[1]'" unless (-d $ARGV[1]);
  createEnum($ARGV[0], $ARGV[1]);
}
else
{
  print $Helpmessage;
}

exit(0);


