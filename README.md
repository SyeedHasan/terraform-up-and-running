# Terraform: Up & Running

## Personal Notes

The `Code` folder has all code or Terraform scripts I've written during the course of reading the book. It has my personal notes but no State files have been pushed (for a good reason, of course).

**Helpful Pointers:**
- Importance of the [Terraform Dependency Lockfile](https://stackoverflow.com/questions/67963719/should-terraform-lock-hcl-be-included-in-the-gitignore-file)
- [Hashes](https://developer.hashicorp.com/terraform/language/files/dependency-lock#new-provider-package-checksums) or Checksums in the Dependency Lock File
- 

## Author's Notes:


This repo contains the code samples for the book *[Terraform: Up and Running](http://www.terraformupandrunning.com)*, 
by [Yevgeniy Brikman](http://www.ybrikman.com).

### Looking for the 1st, 2nd, or 3rd edition?

*Terraform: Up & Running* is now on its **3rd edition**; all the code in `master` is for this edition. If you're looking
for code examples for other editions, please see the following branches:

* [1st-edition branch](https://github.com/brikis98/terraform-up-and-running-code/tree/1st-edition).
* [2nd-edition branch](https://github.com/brikis98/terraform-up-and-running-code/tree/2nd-edition).
* [3rd-edition branch](https://github.com/brikis98/terraform-up-and-running-code/tree/3rd-edition).

### Quick start

All the code is in the [code](/code) folder. The code examples are organized first by the tool or language and then
by chapter. For example, if you're looking at an example of Terraform code in Chapter 2, you'll find it in the 
[code/terraform/02-intro-to-terraform-syntax](code/terraform/02-intro-to-terraform-syntax) folder; if you're looking at 
an OPA (Rego) example in Chapter 9, you'll find it in the 
[code/terraform/09-testing-terraform-code](code/terraform/09-testing-terraform-code) folder.

Since this code comes from a book about Terraform, the vast majority of the code consists of Terraform examples in the 
[code/terraform folder](/code/terraform).

For instructions on running the code, please consult the README in each folder, and, of course, the
*[Terraform: Up and Running](http://www.terraformupandrunning.com)* book.

### License

This code is released under the MIT License. See LICENSE.txt.
