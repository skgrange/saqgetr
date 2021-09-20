# saqgetr 0.2.xx

  - **lubriate** parsers are set to `quiet` after some new messages were being raised. 

# saqgetr 0.2.21

  - New method to fetch remote files using **httr** and status checks which allow for useful messages if the remote files cannot be reached. 
  - The **fs** and **curl** are no longer depends

# saqgetr 0.2.1

  - Alter connection closing for `get_saq_observations` when file does not exist.

# saqgetr 0.2.0

  - Minor changes to improve compatibility with dplyr 1.0.0.

# saqgetr 0.1.19

  - Harden `saq_clean_observations` to handle zero row input data frames/tibbles. Needed to be done for failed CRAN checks due to the New Year.
  - Constrain examples to years to avoid zero row examples.
  - Add **curl** as depends to fix CRAN check notes. 

# saqgetr 0.1.18

  - Explicitly open and close remote connections to avoid the use of `closeAllConnections` in `get_saq_observations`. 
  - Make messaging simpler. 

# saqgetr 0.1.17

  - Resubmisison after CRAN feedback. 
    - Minor changes to title and description text for the package. 

# saqgetr 0.1.16

  - First CRAN submission
