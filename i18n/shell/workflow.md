
# Shell Internationalization Workflow

To provide translations for shell scripts we use the gettext package.

## Preparing a Shell Script for Translation

Shell scripts contain `echo` commands to provide user feedback.

We need for the strings displayed by an `echo` command to be displayed in the language the user of 
the machine is using.

In the top of the script we put these lines:

	export TEXTDOMAIN=myscript
	export TEXTDOMAINDIR=/usr/share/locale

	. gettext.sh

In the above example `myscript` is an example script name.

The `TEXTDOMAINDIR` above contains the usual path to localization for a typical Linux installation. 
It may be raplaced with:

	export TEXTDOMAINDIR=$PWD/locale

For testing a script's translation.

The script author changes typical `cho` of this syntax:

	echo 'Press any key to continue'

With:

	echo $(gettext "Press any key to continue") ; echo

We place an extra `echo` with no arguments at the end because the `gettext` function does not add a line-feed.

The `gettext` function is contained in the `gettext.sh` script included at the top of the script.

If an echoed string contains any shell variables they must be replaced.

For example:

	echo "Program name: $0"

Becomes:

	PROGNAME=$0
	echo $(eval_gettext "Prog name: \$PROGNAME") ; echo

The `eval_gettext` function is used instead of `gettext` and the dolla-sign is `escaped` with a 
back-slash.

Again an extra `echo` is put in after the command to echo a translated string.

## Extracting Strings into a Portable Object Template (.pot)

Now we run `xgettext` against our script to create a file of strings to translate.

We do this in this fashion:

   xgettext -L Shell -o myscript.pot myscript

This reads all the `echo` commands which contain references to the `gettext` and `eval_gettext` functions and writes them to a `.pot` (portable object template) file.

Here is a simple example of the contents of a `.pot` file for a script which contains only one `echo` command:



	# SOME DESCRIPTIVE TITLE.
	# Copyright (C) YEAR THE PACKAGE'S COPYRIGHT HOLDER
	# This file is distributed under the same license as the PACKAGE package.
	# FIRST AUTHOR <EMAIL@ADDRESS>, YEAR.
	#
	#, fuzzy
	msgid ""
	msgstr ""
	"Project-Id-Version: PACKAGE VERSION\n"
	"Report-Msgid-Bugs-To: \n"
	"POT-Creation-Date: 2017-04-19 22:52+0100\n"
	"PO-Revision-Date: YEAR-MO-DA HO:MI+ZONE\n"
	"Last-Translator: FULL NAME <EMAIL@ADDRESS>\n"
	"Language-Team: LANGUAGE <LL@li.org>\n"
	"Language: \n"
	"MIME-Version: 1.0\n"
	"Content-Type: text/plain; charset=UTF-8\n"
	"Content-Transfer-Encoding: 8bit\n"
	#
	#: myscript:10
	#, sh-format
	msgid "Hello world: $PROGNAME"
	msgstr ""


In the above example there are values in upper-case at the top in the comments which should be filled out with the details of the package-name, and the author details etc.

And this line:

    "Content-Type: text/plain; charset=CHARSET\n"

Should be changed to read:

    "Content-Type: text/plain; charset=UTF-8\n"

Or whichever character-set we are using.

## The Translation Process

The first-cut `.pot` file should be passed to a translator with the name changed to drop the ending `t`:

    cp myscript.pot myscript.po

Now give the `.po` (portable object) file to a translator.

After the line which reads:

      "Content-Transfer-Encoding: 8bit\n"

There will be entries of the form:

      msgid "Some string in the original language"
      msgstr ""

A translator places the translation of the string in the `msgid` entry in the `msgstr` entry between the	quotes.

The translator _MUST_ preserve any shell variable reference that is in the original string. For example:

    msgid "Attention! $ERRORCODE"
    	  msgstr "Achtung! $ERRORCODE"

In this way a translator goes right through the file and translates the strings, leaving the `msgid` entries as-is, and placing their translations in the corresponding `msgstr` entries.

## Creating `Machine Object` Files

The files which will actually be used when a script runs, to provide translated strings is a `.mo` file.

We create this from a `.po` file like this:

   msgfmt -o myscript.mo myscript.po

Which will create `myscript.mo` from `myscript.po`.

## Merging New Strings

Of course the development of a complex script is never static and it may be necessary to add new strings, or to remove old ones. We can use another utility to `merge` strings from a new `.pot` file into our `.po` file and re-create our `.mo` file.

For this we use `msgmerge`, like this:

    msgmerge -U myscript.po myscript.pot

This will search the `.pot` file for new or deleted strings and merge them into the `.po` file. In this way previous translation work is not lost when things change.

And again we then create a new `.mo` file from the update `.po` file.

## Installing a Translation

Using our `myscript` example from above, the `.mo` file is installed in:

      /usr/share/locale/<LANG>/LC_MESSAGES/myscript.mo

Where <ALANG> is the language into which the script has been translated.

For example, for Brazilian Portuguese:

    /usr/share/locale/pt_BR/LC_MESSAGES/myscript.mo

## The Worklow in Short

1. Script is written and tested, including gettext support.
2. Run `xgettext` to extract all `echo` strings into a `.pot` file.
3. Rename the `.pot` file to `.po` and pass to translator.
4. When step 3 is done, run `msgfmt` to create the `.mo` file.
5. Install the `.mo` file (after testing).
6. If something new is written in the script, go to step 2 and repeat to step 5.

## Notes/Suggestions

The `.po` files to be translated should probably either be contained in a directory structure which clearly defines the language, or should contain the language in the file-name, although the completed `.mo` file cannot.

So, for `myscript`, perhaps:

    myscript/
		en/myscript.en.po (English)
				fr/myscript.fr.po (French)
							pt_BR/myscript.pt_BR.po (Brazilian Portuguese)

