## simple functions for printing messages on interface
import strutils

proc printStart*() =
    echo("")
    echo("---------------------------------------------")
    echo("Search engine for Ancient Greek Texts Started")
    echo("---------------------------------------------")
    echo("")

proc printNoArgMessage*() =
    echo(
    "You have not specified any of" &
    "the parameters through command line interface. "
    )
    echo("")

proc handleSeparator*(): string =
    echo("Please enter your separator." &
         "The default one is three exclamation marks (!!!): ")
    echo("")
    result = stdin.readLine()
    if result == "":
        result = "!!!"
    echo("")

proc gatherSearchTerms*(separator: string): string =
    echo("Please enter search terms separated by " & separator)
    echo("Ex: μάχης φασὶ χρῆναι" &
         separator &
         "μάχης φασὶ χρῆναι" & separator & "ὑστεροῦμεν"
        )
    echo("")
    echo("Please do note that your terms are used as is." &
         "No tokenization is performed")
    echo("")
    echo("Now please enter your search terms:")
    echo("")
    result = stdin.readLine()
    echo("")

proc printFilterSearchTerms*(terms, sep: string): seq[string] =
    var enteredTerms = split(terms, sep)
    echo("You have entered the following terms:")
    for term in enteredTerms:
        if term != "":
            echo("\t"&term)
            result.add(term)




