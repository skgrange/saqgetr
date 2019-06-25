# New package submission

This is a new package submission.

# Test environments

  - Local, Ubuntu 18.04.1 LTS, R 3.6.0
  
  - Travis CI, Ubuntu 14.04.5 LTS, R 3.6.0
  
  - [win-builder](https://win-builder.r-project.org/), Windows Server 2008, (R-release and R-devel) 
  
  - R-Hub
    - Windows Server 2008 R2 SP1, R-devel, 32/64 bit
    - Ubuntu Linux 16.04 LTS, R-release, GCC
    - Fedora Linux, R-devel, clang, gfortran

# R CMD check results

The R CMD checks produce no errors or warnings but one note because this is a new submission:

```
0 errors | 0 warnings | 1 note

checking CRAN incoming feasibility ... NOTE
Maintainer: 'Stuart K. Grange <stuart.grange@york.ac.uk>'
New submission
```

# Other comments

This is a new package. 

There are two examples which can take longer than five seconds to run. Therefore have been documented with the use of `donttest` (`get_saq_observations` and `get_saq_simple_summaries`).

# Downstream dependencies

This package has has no downstream dependencies.
