# How To Contribute

Thanks for wanting to contribute to code examples for the mortality data quality assessment framework! A few tips and links to guidance for various facets of contribution can be found below.

## Creating Issues

If you would like something to be changed on the repository, you can open an issue: a short description of a request or change they would like to be made. You can find those as one of the tabs at the top of the repository. For more information on issues, see GitHub documentation [here](https://docs.github.com/en/issues/tracking-your-work-with-issues/using-issues/creating-an-issue).

If reporting a bug/problem, please make sure to report:
- What version of the repository you're using
- Exact inputs to functions used
- Exact error messages as they appear in the console/terminal
- Any other information that would be helpful to replicate the message

## Updating Data

After updating CSVs in [data](data), data updates need to be passed to the R package. To do this:

1. Open dqa4mortality.Rproj (found under R/dqa4mortality) in RStudio.
2. Open and re-run all scripts in [R/dqa4mortality/data-raw](R/dqa4mortality/data-raw).

Then submit a pull request to add these changes to the repository, as detailed below.

## Pull Requests

When you would like to change something on the repository, you’ll need to go through a pull request process:
- First, someone opens a pull request with their changes to the code (documentation [here](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/proposing-changes-to-your-work-with-pull-requests/creating-a-pull-request))
- The repository maintainer then reviews the pull request and asks for any additional changes (documentation [here](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/reviewing-changes-in-pull-requests/about-pull-request-reviews) and [here](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/reviewing-changes-in-pull-requests/reviewing-proposed-changes-in-a-pull-request))
- Then, once all comments from the review are addressed, the maintainer approves the changes and merges them into the main repository (documentation [here](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/incorporating-changes-from-a-pull-request/about-pull-request-merges))

If making changes to the R package, before creating a pull request, make sure to run `devtools::check()` and resolve all ERRORs and WARNINGs. NOTEs should be addressed as well. For more information on running checks for R packages, please see the R Packages book [here](https://r-pkgs.org/workflow101.html#sec-workflow101-r-cmd-check).

