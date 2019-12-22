# Security information
## Supported releases
Since there is no stable release at this time, we expect you to run the latest
available version (`master`).

## General guidelines
At a minimum, a security report should contain:

* a descriptive, short title;
* the catoolbox version number/commit hash;
* the operating system/version/patch level you run your tests on;
* a description of the vulnerability, including the steps to reproduce it.

_Great_ security reports also include:

* a minimal proof of concept;
* an analysis of the nature of the vulnerability;
* guidance to fix the bug.

## How to report a vulnerability
In case you have found a security bug, **do not open a GitHub issue** to avoid
revealing potentially sensitive details.

Send an e-mail to Alessandro Menti (the project maintainer) at the address
listed on [his GitHub profile](https://github.com/AlessandroMenti/), preferably
encrypted with [his GPG key](https://www.alessandromenti.it/downloads/pubkey-0xBF334213F5C5CA03.asc),
using the template below.

## How we handle vulnerability reports
The typical process for handling vulnerability reports is:

1. The report is e-mailed to the catoolbox maintainer.
2. Any messages not related to vulnerabilities in catoolbox are ignored.
3. We acknowledge receipt of the report.
4. We investigate the report and either reject it (detailing the reasons) or
   accept it.
5. In case the report is accepted, we work on a fix and commit it to a private
   branch, draft a [security advisory](https://github.com/AlessandroMenti/catoolbox/security/advisories)
   and request a [CVE number](https://cve.mitre.org/) (if one was not already
   provided in the report). We then inform the reporter about the fix and
   verify that it solves the vulnerability.
6. Once the fix is verified and tested, we will incorporate the fix in the
   upcoming release. In case the next planned release is judged to be too far
   away by the reporter and/or the security team, an earlier release should be
   considered.
7. At release time, the private branch is merged into the master branch and
   pushed. The new release and the vulnerability are announced.

## Security template
Use this template to draft a new vulnerability report.

```
* Vulnerability title:
* catoolbox version number/commit hash:
* Operating system/version number/patch level:
* Description:
* Was the vulnerability already made public and, if yes, where?
* Was a CVE number already assigned to this vulnerability? If yes, give it.
* Vulnerability analysis:
* Proof of concept code:
* Notes/guidance to fix the bug:
* How would you like to be credited in the vulnerability announcement?
* GitHub username (if given, this will allow you to collaborate to the
  security advisory and fix before they are published):
```
