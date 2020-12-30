% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/read.nafoB.r
\name{read.nafoB}
\alias{read.nafoB}
\title{read nafoB files}
\usage{
read.nafoB(path, year = NULL, species = NULL, overwrite = FALSE)
}
\arguments{
\item{path}{path to which to download raw files}

\item{year}{vector of years to read (all by default)}

\item{species}{species name(s)}

\item{overwrite}{download again? see Details}
}
\description{
read nafoB files
}
\details{
Download data from https://www.nafo.int/Data/Catch-Statistics
If overwrite = FALSE and downloaded data is already at specified path, just read the local data
See find.species to get the species names used in the database
}