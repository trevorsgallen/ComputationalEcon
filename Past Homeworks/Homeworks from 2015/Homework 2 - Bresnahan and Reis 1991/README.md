This homework, given in 2015, runs students through Timothy Bresnahan and Peter Reiss's 1991 Journal of Political Economy article "Entry and Competition in Concentrated Markets"

In this code, I run a maximium likelihood model by hand, replicating the last column in Table 4 from Bresnahan and Reiss (1991).

1.  BR.m takes in parameters (to be estimated) and spits out the log likehood.
2.  BresnahanReiss.m:
  a.  Reads in data
  b.  Minimizes the log likelihood
  c.  Calculates standard errors using Fisher's Information Matrix
