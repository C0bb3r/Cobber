#!/usr/bin/perl

use v5.10 ;

# en_AU.pl is a modified version of en_GB.pl developed by the Gnome en_GB
# translation team. The en_GB copyright and other information is below
# for reference purposes only. Some parts, those that do not suit Australian
# and/or New Zealand English have been removed. A concise How to use en_AU.pl
# is at the end of this section.

## (c) 2000 Abigail Brady
##     2002-2006 Bastien Nocera
##     2005 James A. Morrison
#     2011-* Michael Findlay (en_AU coordinator 2011-*)
#     2012 Markush (LinuxQuestions)

## Released under the GNU General Public Licence, either version 2
## or at your option, any later version

## NO WARRANTY!

## Script to take a .pot file and make an en_GB translation of it.
## since full AI hasn't been invented yet, you need to inspect it
## by hand afterwards.
##
## Interactive mode added for certain words by Peter Oliver, 2002-08-25.

## These are as-is

# en_AU         Australian English # One of 2 main versions for this particular file #
# en_CX         Christmas Island English
# en_HM         Heard & McDonald Islands English
# en_NF         Norfolk Island English
# en_NZ         New Zealand English # One of 2 main versions for this particular file #
# en_PN         Pitcairn English

## If you find an inaccuracy in this list or any other problem with the script,
## please let me know at the email address listed and I will adjust it accordingly.

# How to use en_AU.pl
#
# In your /home directory create a folder (e.g. Gnome) and within that folder
# create another one (e.g. Gnome3.4) and another within to suit Gnome's structure.
# My setup for Gnome 3.4 is /home/username/Gnome/Gnome3.4/ui and 
# /home/username/Gnome/Gnome3.4/ui-translated. I do this for each of Gnome's
# particular translation areas like ui, documentation etc.
#
# As root open a terminal and cd into the folder you are working on
# (e.g. cd /home/username/Gnome/Gnome3.4/ui). Now to translate each individual file
# just type (in the terminal and without the "quotation marks") 
# "perl en_AU.pl at-spi2-core.master.pot > /home/michael/Gnome/Gnome3.4/ui-translated/at-spi2-core.master.pot"
# If there are any strings that need translating en_AU.pl will automatically
# translate the strings. If there are strings that can have more than one
# meaning en_AU.pl will ask you to make a choice between the options. When the file is
# translated it will be in the "translated" folder. After you have completed your
# translations have them committed through the proper channels.
#
# The file has since been modified further, with the help of Markush from LinuxQuestions.org forums (http://www.linuxquestions.org/questions/programming-9/modify-script-to-do-mass-file-translation-instead-of-1-file-at-a-time-4175434429/)   # and is now capable of mass translations. Place en_AU.pl in the folder with all the .po. and/or .pot files
# click on it and allow it to run in a terminal (it must be made executable).
#
# You will see in the word list many words commented out with ## marks in front of them. I have done
# this because some are simply not relevant to this purpose but are used by others who can "uncomment"
# them is they wish to.

# NO WARRANTY!

use strict;
use warnings;
use Time::gmtime;
use Term::ReadLine;
use vars qw($msg_str $msg_id $locale $rl $check_mode);

sub do_trans {
  my ($tf, $tt) = @_;
  my ($accel, $upper_tt);

	# Handle keyboard shortcuts in message strings.  Messy, but it seems to work.
	# Use the same key if possible, otherwise prompt the user.
	my $underscores_tf = $tf;
	$underscores_tf =~ s/(?<=\w)(.)/_?$1/g;
	if ( $msg_str =~ m/(_?$underscores_tf)/i and $1 =~ m/_(\w)/ ) {
		my $accel = $1;
		if ( $tt =~ s/(?=$accel)/_/i ) {
		if ( $tt =~ m/^_$accel/i ) {
			$upper_tt = $tt;
			$upper_tt =~ s/^_(.)/_\u$1/;
		}
		}
		else {
		my $nonl = $msg_str;
		chomp $nonl;
		print STDERR "\nI want to change '$tf' to '$tt' in the message $nonl, but don't know where to put the accelerator.\n";
		$rl->addhistory( $nonl );
		$msg_str = $rl->readline( 'New msg_str? ' ). "\n";
		print STDERR "Replaced.\n";
		return;
		}
	}

  $msg_str =~ s/(\b|_)\u$underscores_tf/$upper_tt/g and return
      if defined $upper_tt;
  $msg_str =~ s/(\b|_)$underscores_tf/$tt/g;
  $msg_str =~ s/(\b|_)\u$underscores_tf/\u$tt/g;
  $msg_str =~ s/(\b|_)\U$underscores_tf/\U$tt/g;
}

sub query_trans {
    my ($tf, $tt, $context) = @_;
    if ( $msg_str =~ m/\b$tf/i ) {
    	my $result;

	print STDERR "\nmsgid: ${msg_id}msgstr: $msg_str";
	if ($context) {
	    $result = $rl->readline( "Change '$tf' to '$tt'? (Context: '$context') (y/N) " );
        } else {
            $result = $rl->readline( "Change '$tf' to '$tt'? (y/N) " );
        }
	if ( $result =~ m/^\s*y(es)?\s*$/i ) {
	    print STDERR "Changed\n";
	    do_trans( $tf, $tt );
	}
	else {
	    print STDERR "Not changed\n";
	}
    }
}

sub translate() {
  my $old_msg_str;

  if (!$check_mode) {
    # We're doing a normal translation
    if (!($msg_str eq "\"\"\n")) {
      my $date = sprintf("%04i-%02i-%02i %02i:%02i+0000", gmtime()->year+1900,
      gmtime()->mon+1, gmtime()->mday, gmtime()->hour, gmtime()->min);

      $msg_str =~ s/YEAR-MO-DA HO:MI\+ZONE/$date/;
      $msg_str =~ s/YEAR-MO-DA HO:MI\+DIST/$date/;
      $msg_str =~ s/FULL NAME <EMAIL\@ADDRESS>/Michael Findlay <translate\@cobber-linux.org>/;
      $msg_str =~ s/CHARSET/UTF-8/;
      $msg_str =~ s/ENCODING/8-bit/;
      $msg_str =~ s/LANGUAGE <LL\@li.org>/Australian English en_AU/;
      $msg_str =~ s/Plural-Forms: nplurals=INTEGER; plural=EXPRESSION/Plural-Forms: nplurals=2; plural=n != 1;/;
      return;
    }

    # Epiphany-style contexting
    # FIXME we should save the context and pass it
    if ( $msg_id =~ m/^.*\|(.*)$/ ) {
      $msg_str = "\"".$1."\n";
    } else {
      $msg_str = $msg_id;
    }
  } else {
    # We're checking for differences between a translation and the original strings
    # Skip the header and translation-credits strings (they're boring)
    if ($msg_id eq "\"\"\n" or $msg_id eq "\"translator-credits\"\n" or $msg_id eq "\"translator_credits\"\n") {
      return;
    }

    if ($msg_str eq "\"\"\n") {
      print "\nUntranslated string\n";
      print "C string: ${msg_id}\n\n";
      return;
    }

    $old_msg_str = $msg_str;
    $msg_str = $msg_id;
  }

### A ###
  ##query_trans("acronym", "initialism"); ##From Ubuntu en_AU word substitution list. Commented out because it really isn't relevant.
  do_trans("adapter", "adaptor"); ##From Ubuntu en_AU word substitution list
  ##do_trans("adrenalin", "adrenaline"); ##From Ubuntu en_AU word substitution list. Commented out because it really isn't relevant.
  ##query_trans("agenda", "agendum"); ##From Ubuntu en_AU word substitution list. Commented out because I'm not sure this is accurate.
  do_trans("airplane", "aeroplane"); ##From Ubuntu en_AU word substitution list. Is this relevant to operating systems?
  do_trans("aluminum", "aluminium");
  do_trans("analog", "analogue");
  do_trans("analyze", "analyse");
  do_trans("analyed", "analysed");
  do_trans("analyzer", "analyser");
  do_trans("analyzing", "analysing");
  ##query_trans("anchor", "newsreader"); ##From Ubuntu en_AU word substitution list. Commented out because it really isn't relevant and it is also a generalisation.
  do_trans("anemia", "anaemia"); ##From Ubuntu en_AU word substitution list. Is this relevant to operating systems?
  do_trans("anesthesia", "anaesthesia"); ##From Ubuntu en_AU word substitution list. Is this relevant to operating systems?
  do_trans("anesthesiologist", "anesthetist"); ##From Ubuntu en_AU word substitution list. Is this relevant to operating systems?
  do_trans("anesthetic", "anaesthetic"); ##From Ubuntu en_AU word substitution list. Is this relevant to operating systems?
  ##query_trans("annex", "annexe"); ##From Ubuntu en_AU word substitution list. Commented out because I'm not sure this is accurate or how relevenant it is to operating systems.
  do_trans("antennas", "antenae"); ##From Ubuntu en_AU word substitution list.
  ##do_trans("antialiased", "anti-aliased"); ##From Ubuntu en_AU word. substitution list. Commented out because I'm not sure this is accurate
  ##do_trans("anymore", "any more"); ##From Ubuntu en_AU word substitution list. Commented out because I'm not sure this is accurate.
  ##do_trans("ass", "arse"); ##From Ubuntu en_AU word substitution list. Commented out because I'm not sure this is accurate or relevant to operating systems.
  do_trans("armor", "armour");
  ##do_trans("artifact", "artefact"); ##From Ubuntu en_AU word substitution list.
  do_trans("authorization", "authorisation");
  ##do_trans("authorizational", "authorisational"); ##From Ubuntu en_AU word substitution list. Commented out because I'm not sure this is even a real word.
  do_trans("authorize", "authorise");
  do_trans("authorized", "authorised");
  do_trans("authorizing", "authorising"); ##From Ubuntu en_AU word substitution list.
  ##do_trans("automobile", "motorcar"); ##From Ubuntu en_AU word substitution list. Commented out because I'm not sure this is accurate. I am a mechanic by trade and I use the word "automobile" but never use "motorcar" instead I would simply say "car".
  do_trans("ax", "axe");
  do_trans("axeis", "axis");  ##To correct bug created by translation from ax to axe.
### B ###
  do_trans("behavior","behaviour");
### C ###
  do_trans("caliber", "calibre");
  #query_trans("can", "bin");
  do_trans("cancelation", "cancellation");
  do_trans("canceled", "cancelled");
  do_trans("canceling", "cancelling");
  do_trans("capitalize", "capitalise");
  do_trans("capitalization", "capitalisation");
  do_trans("capitalizing", "capitalising");
  query_trans("cart", "trolley"); ##From Ubuntu en_AU word substitution list. I have made this query because golf carts are not called golf trolleys.
  query_trans("caster", "castor", "caster refers to suger, castor refers to wheel alignment"); ##From Ubuntu en_AU word substitution list.
  do_trans("catalog", "catalogue");
  do_trans("categorization", "categorisation");
  do_trans("categorize", "categorise");
  do_trans("categorized", "categorised");
  query_trans("cell", "mobile", "Refers to phones");
  do_trans("centimeter", "centimetre");
  do_trans("centered", "centred");
  do_trans("center", "centre");
  do_trans("centigrade", "celsius");
  ## These are less common, and the below translations are more useful, see bgo#628507.
  ##query_trans("checked", "chequered", "Refers to patterns");
  ##query_trans("check", "cheque", "Refers to a payment method");
  #query_trans("checkbox", "tickbox", "Refers to an UI element");
  #query_trans("checked", "ticked", "Refers to an UI element");
  #query_trans("check", "tick", "Refers to an UI element");
  do_trans("cipher", "cypher");
  do_trans("color", "colour");
  do_trans("colored", "coloured");
  do_trans("colorize", "colourise");
  do_trans("colorized", "coloured");
  do_trans("customizable", "customisable");
  do_trans("customization", "customisation");
  do_trans("customize", "customise");
  do_trans("customized", "customised");
  do_trans("customizing", "customising");
### D ###
  do_trans("daemonize", "daemonise");
  do_trans("defense", "defence");
  do_trans("deserialize", "deserialise");
  do_trans("deserialized", "deserialised");
  do_trans("deserializing", "deserialising");
  do_trans("dialer", "dialler");
  do_trans("dialing", "dialling");
  do_trans("dialed", "dialled");
  do_trans("dialog", "dialogue");
  do_trans("digitize", "digitise");
  do_trans("digitized", "digitised");
  do_trans("digitizer", "digitiser");
  do_trans("digitizing", "digitising");
  #query_trans("disc", "disk", "disc for CD-DVD or round objects otherwise disk");
  do_trans("diskard", "discard");
  do_trans("diskarded", "discarded");
  do_trans("diskarding", "discarding");
  do_trans("diskonnect", "disconnect");
  do_trans("diskonnected", "disconnected");
  do_trans("diskonnecting", "disconnecting");
  do_trans("diskontinuous", "discontinuous");
  do_trans("diskover", "discover");
  do_trans("diskovery", "discovery");
  do_trans("diskharging", "discharging");
  do_trans("diskrete", "discrete");
### E ###
  ##do_trans("eggplant","aubergine"); ##en_GB does this fit en_AU?
  query_trans("earth", "ground");
  query_trans("earth", "negative");
  do_trans("encyclopedia", "encyclopaedia");
  do_trans("endeavor", "endeavour");
  do_trans("equaled", "equalled");
  do_trans("equaling", "equalling");
  do_trans("equalize", "equalise");
  do_trans("equalized", "equalised");
  do_trans("equalizer", "equaliser");
  do_trans("equalizing", "equalising");
### F ###
  do_trans("favor", "favour");
  do_trans("favored", "favoured");
  do_trans("favorite", "favourite");
  do_trans("featureful", "full-featured");
  do_trans("fiber", "fibre");
  do_trans("finalize", "finalise");
  do_trans("finalizing", "finalising");
  do_trans("flavor", "flavour");
  do_trans("formating", "formatting");
  do_trans("fueled", "fuelled");
  do_trans("fueling", "fuelling");
### G ###
  do_trans("garbage", "rubbish");
  do_trans("gray", "grey");
  do_trans("grayscale", "greyscale");
  query_trans("ground", "earth");
  query_trans("ground", "negative");
  query_trans("grounded", "earthed");
  query_trans("grounding", "earthing");
### H ###
  query_trans("harbor", "harbour");
  do_trans("honor", "honour");
  do_trans("humor", "humour");
### I ###
  do_trans("initialize", "initialise");
  do_trans("initializing", "initialising");
  do_trans("initialization", "initialisation");
  do_trans("initialized", "initialised");
  do_trans("insuficient", "insufficient");
  do_trans("internationalization", "internationalisation");
  do_trans("intemization", "itemisation");
  do_trans("itemize", "itemise");
  do_trans("itemized", "itemised");
### J ###
  do_trans("jeweled", "jewelled");
  do_trans("judgment", "judgement");
### K ###
  do_trans("kilometer", "kilometre");
### L ###
  do_trans("labeled", "labelled");
  do_trans("license", "licence"); # http://www.oxforddictionaries.com/definition/english/licence
  do_trans("licensed", "licenced");
  do_trans("licencing", "licensing");
  do_trans("labor", "labour");
  do_trans("liter", "litre");
  do_trans("litreal", "literal"); # Because "liter" sometimes affects other words (FIXME: bug #574576)
  do_trans("litreate", "literate");
  do_trans("litreature", "literature");
  do_trans("localize", "localise");
  do_trans("localized", "localised");
  do_trans("localization", "localisation");
### M ###
  do_trans("maintainance", "maintenance");
  do_trans("maintanance", "maintenance");
  do_trans("maximization", "maximisation");
  do_trans("maximize", "maximise");
  do_trans("maximized", "maximised");
  query_trans("meter", "metre", "meter refers to a measurement gauge (i.e. water meter), metre refers to measurement of length (i.e. one metre)" );
  do_trans("metreing", "metering"); # Because "meter sometimes affects other words.
  do_trans("millimeter", "millimetre");
  do_trans("minimize", "minimise");
  do_trans("minimized", "minimised");
  do_trans("misspelled", "misspelt");
  do_trans("mobileular", "mobile");# fix mistake made by correcting cell in cellular to mobile.
  do_trans("modeled", "modelled");
  do_trans("modeler", "modeller");
  do_trans("modeling", "modelling");
### N ###
  do_trans("neighbor", "neighbour");
  do_trans("normalize", "normalise");
  do_trans("normalizing", "normalising");
  do_trans("normalization", "normalisation");
### O ###
  do_trans("occured", "occurred");
  do_trans("occurence", "occurrence");
  do_trans("offense", "offence");
  do_trans("optimization", "optimisation");
  do_trans("optimizations", "optimisations");
  do_trans("optimize", "optimise");
  do_trans("optimized", "optimised");
  do_trans("optimizing", "optimising");
  do_trans("organize", "organise");
  do_trans("organizing", "organising");
  do_trans("organized", "organised");
  do_trans("organization", "organisation");
  do_trans("organizational", "organisational");
### P ###
  do_trans("paneled", "panelled");
  do_trans("paneling", "panelling");
  do_trans("personalize", "personalise");
  do_trans("personalizing", "personalising");
  do_trans("popularized", "popularised");
  query_trans("practise", "practice", "practise is a verb, practice is a noun");
  do_trans("prioritize", "prioritise");
  do_trans("prioritizing", "prioritising");
### Q ###
###R ###
  do_trans("randomize", "randomise");
  do_trans("realize", "realise");
  do_trans("realized", "realised");
  do_trans("realizing", "realising");
  do_trans("realization", "realisation");
  do_trans("recognize", "recognise");
  do_trans("rumor", "rumour");
### S ###
  do_trans("saber", "sabre");
  do_trans("scepter", "sceptre");
  do_trans("serialized", "serialised");
  do_trans("serialization", "serialisation");
  do_trans("signaled", "signalled");
  do_trans("signaling", "signalling");
  do_trans("simultanous", "simultaneous");
  do_trans("specialized", "specialised");
  do_trans("specter", "spectre");
  do_trans("spelled", "spelt");
  do_trans("stickyness", "stickiness");
  do_trans("sulfur", "sulphur");
  do_trans("summarize", "summarise");
  do_trans("syncronize", "synchronise");
  do_trans("synchronization", "synchronisation");
  do_trans("synchronize", "synchronise");
  do_trans("synchronized", "synchronised");
  do_trans("synchronizes", "synchronises");
  do_trans("synchronizing", "synchronising");
### T ###
  do_trans("theater", "theatre");
  query_trans("tire", "tyre");
  do_trans("totaled", "totalled");
  do_trans("totaler", "totaller");
  do_trans("totaling", "totalling");
  do_trans("translator_credits", "Michael Findlay <translate\@cobber-linux.org>");
  do_trans("trash", "rubbish");
  do_trans("tunneling", "tunnelling");
### U ###
  do_trans("unauthorized", "unauthorised");
  do_trans("uncategorized", "uncategorised");
  do_trans("unmaximize", "unmaximise");
  do_trans("unminimize", "unminimise");
  do_trans("unminimized", "unminimised");
  do_trans("unminimizing", "unminimising");
  do_trans("unrecognized", "unrecognised");
  do_trans("utilization", "utilisation");
  do_trans("utilize", "utilise");
  do_trans("utilized", "utilised");
  do_trans("utilizing", "utilising");
### V ###
  do_trans("vapor", "vapour");
  do_trans("vise", "vice");
  do_trans("visualize", "visualise");
  do_trans("visualized", "visualised");
  do_trans("visualization", "visualisation");
  do_trans("visualizing", "visualising");
### W ###
  do_trans("wastebasket", "rubbish bin");
  do_trans("writting", "writing");
### X ###
### Y ###
### Z ###

# This causes the string not to be copied
#  if ($msg_str eq $msg_id) {
#    $msg_str = "\"\"\n";
#  }

  if ($check_mode and !($old_msg_str eq $msg_str)) {
    print "C string:              ${msg_id}";
    print "Automated translation: ${msg_str}";
    print "Manual translation:    ${old_msg_str}";
    print "\n";
  }
}

# Modes:
# 1 = adding to msgid
# 2 = adding to msgstr
# 3 = adding to plural msgid
# 4 = adding to plural msgstr
my $mode = 0;

$check_mode = ($#ARGV eq 1 and $ARGV[0] eq "--check");
$rl = Term::ReadLine->new("String Replacement");
$locale = $ENV{'LANG'};
$locale =~ s/\..*//g;

my $msg_id2 = "";
my $msg_str2 = "";
$msg_str = "";

opendir DIR, "." ;
while (readdir DIR) {
	if ($_ =~ m/.*\.pot?/) {   # matches .po and .pot at the end of a filename
		my $newfile = $_ ;
		# say $newfile ;
		# exit ;
		open NEWFILE, ">>./Translated/$newfile" ;
		open FILE, "$_" ;
		while ( <FILE> ) {
		if  (/^#/ and !$check_mode) {
		s/SOME DESCRIPTIVE TITLE/English (Australian) translation/;
		my $year = gmtime()->year+1900;
		s/YEAR/$year/;
		s/FIRST AUTHOR <EMAIL\@ADDRESS>/Michael Findlay <keltoiboy\@gmail.com>/;
		print unless ((/^#, fuzzy/) && ($mode eq 0));
	} elsif (/^msgid_plural /) {
		$msg_id2 .= substr($_, 13);
		$mode = 3;
	} elsif (/^msgstr\[0\]/) {
		$msg_str .= substr($_, 10);
		$mode = 2;
	} elsif (/^msgstr\[1\]/) {
		$msg_str2 .= substr($_, 10);
		$mode = 4;
	} elsif (/^msgid /) {
		$msg_id .= substr($_, 6);
		$mode = 1;
	} elsif (/^msgstr "/) {
		$msg_str .= substr($_, 7);
		$mode = 2;
	} elsif (/^"/) {
		if ($mode == 1) {
			$msg_id .= $_;
			$mode = 1;
		} elsif ($mode == 3) {
			$msg_id2 .= $_;
			$mode = 3;
		} elsif ($mode == 2) {
			$msg_str .= $_;
			$mode = 2;
		} elsif ($mode == 4) {
			$msg_str2 .= $_;
			$mode = 4;
		}
	} else {
		my $line = $_;

		if (defined $msg_id2 && $msg_id2 ne "") {
			translate();
			if (!$check_mode) {
				print NEWFILE "msgid $msg_id";
				print NEWFILE "msgid_plural $msg_id2";
				print NEWFILE "msgstr[0] $msg_str";
			}

			$msg_id = $msg_id2;
			$msg_str = $msg_str2;
			translate();
			if (!$check_mode) {
				print NEWFILE "msgstr[1] $msg_str";
			}
			$msg_id = "";
			$msg_id2 = "";
			$msg_str = "";
			$msg_str2 = "";
		} elsif ($msg_id || $msg_str) {
			translate();
			if (!$check_mode) {
				print NEWFILE "msgid $msg_id";
				print NEWFILE "msgstr $msg_str";
			}
			$msg_id = "";
			$msg_id2 = "";
			$msg_str = "";
			$msg_str2 = "";
		}

		if (!$check_mode) {
			print NEWFILE $line;
		}
	}
}
	}
	close FILE;
	close NEWFILE;

if ($msg_id || $msg_str) {
	translate();
	if (!$check_mode) {
		print NEWFILE "msgid $msg_id";
		print NEWFILE "msgstr $msg_str";
	}
	$msg_id = "";
	$msg_str = "";
}
}
