# Security Policy

## Supported Scope

Security reports are welcome for the current default branch and for the active runtime/export pipeline represented by this repository.

## Reporting A Vulnerability

Do not open public issues for security vulnerabilities.

Authoritative reporting path:

1. Use GitHub private vulnerability reporting for this repository.
2. Include reproduction details, impact, affected files, and any proposed mitigation.

Fallback when private reporting is unavailable:

1. Do not publish technical details in a public issue.
2. Open a minimal public issue that only requests a private contact channel from the maintainer.
3. Address the request to the project owner, Danil Silantyev (`rldyourmnd`), without disclosing the vulnerability details publicly.

## What To Report

- Secret handling or credential exposure
- Unsafe bootstrap or install behavior
- Rules or automation that allow dangerous actions too broadly
- Supply-chain or integrity issues in the restore pipeline
- Documentation that could cause users to expose secrets or unsafe state

## Response Expectations

Reports will be triaged, reproduced where possible, and addressed according to severity and maintainership capacity.
Please avoid public disclosure until the issue has been reviewed.
