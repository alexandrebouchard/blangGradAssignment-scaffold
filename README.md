# Assignment on Blang

## Prerequisites

I assume you have already done the following (lecture and office hour last week):

- Install Blang IDE.
- Signed up to github (a free account is enough).
- Some basic exposure to Blang (from Sohrab's tutorial and/or the [Blang documentation](https://www.stat.ubc.ca/~bouchard/blang/)). Feel free to ask questions on Piazza and office hours. 

We strongly encourage that you come to Wednesday office hours to get started so that we can provide more guidance.

## Setup

- Click on ``Fork`` (top right).
- Clone the forked repo into your Blang IDE's workspace folder.
- ``cd`` into the cloned repo, then type ``./gradlew eclipse``.
- Import the project into eclipse.


## Implementing samplers over matchings

Efficient sampling over combinatorial spaces is an extremely important but neglected problem. For example, in computational biology, a vast array of pipelines depend on [multiple sequence alignment](https://en.wikipedia.org/wiki/Multiple_sequence_alignment). It is well known that treating multiple sequence alignment as a maximization problem gives rise to issues such as over-alignment and incomplete assessment of uncertainty. The problem is neglected in part because of the scarcity of tools that help to face the challenges involved with the construction of correct and efficient samplers over combinatorial spaces. Blang alleviates this issue: we overview here a powerful testing framework for such samplers.


### Tour of the code harness

Use ``Open Type`` in eclipse to open and read the comments in the following files:
 
- ``Permutation.xtend`` (look also into its base class, ``MatchingBase.xtend``)
- ``UniformPermutation.bl``
- ``PermutationSampler.java``


### Basic sampler for permutations

Design an invariant and irreducible sampler for permutations. Describe formally the proposed moved and establish irreducibility and invariance with respect to the uniform distribution on the space of perfect bipartite matchings (equivalently, permutations).


### Non-uniform case

Generalize your sampler to non-uniformly distributed permutations.


### Implementation

Implement the sampler for non-uniform permutations in ``PermutationSampler.execute``. 

When you are done, you can test your work as follows:

- Right click on the file ``TestPermutation``, and select ``Run As > JUnit Test``
- You will see a Green or Red sign depending on whether the sampler you implemented is indeed invariant and irreducible on a small example. 


### Understanding the test

Use ``Open Type`` in eclipse to open and read the comments in the following files:

- ``DiscreteMCTest.java``
- ``ExhaustiveDebugRandom.java``

Study how these object work. For example, you may want to try using ExhaustiveDebugRandom to automatically construct the decision tree induced by a simple random process such as a Polya urn. 

Summarize these algorithms with a description and pseudo-code. Explain why the kernels are tested separately for invariance but mixed together along with an identify matrix for testing irreducibility. 


### Submission

To submit your code, we use a Continuous Integration framework which automatically runs test cases on the cloud. This seems a bit convoluted but this method teaches you a useful practice: *regression testing*. By running a suite of test cases automatically each time you commit code, you can get notified (by email) when you inadvertently break a piece of code that was formerly working (hence the term 'regression'). This is easy to setup nowadays:

- Push your answers into the cloned public github repo (note, we trust you will not peek at each other's answers since this is a PhD level course).
- Create a free Travis account at [https://travis-ci.org/](https://travis-ci.org/).
- Sign-in to Travis and enable continuous integration (CI) for your assignment repository.
- Add the following link to the file ``README.md`` making sure to substitute ``YOUR_USER_NAME`` and ``REPO_NAME``

```
[![Build Status](https://travis-ci.org/YOUR_USER_NAME/REPO_NAME.png?branch=master)](https://travis-ci.org/YOUR_USER_NAME/REPO_NAME)
```

- Push again, and now you will see, on the github page of your repo, a badge showing the status of the test cases. We will use the automatically generated report to perform grading.
- You can do this procedure as often as you want.

Note: if, in the future, you are interested in using this for your own code (there are tools to make this works for pretty much any programming languages), there will be one extra step to do (setting up a ``.travis.yml`` file in the repo, which I have done for you in this assignment). This is explained at [https://docs.travis-ci.com/user/getting-started/](https://docs.travis-ci.com/user/getting-started/). 


### Bipartite matching (non-perfect)

To make things a bit more interesting, consider now the problem of sampling bipartite matchings, i.e. we do not require the matching to be perfect anymore (vertices do not have to be covered). 

The datastructure is implemented for you in ``BipartiteMatching.xtend``, which you should have a look at. Your job is to implement a sampler for this combinatorial space in ``BipartiteMatchingSampler.java``, which you can test via ``TestBipartiteMatching.xtend``.


## A statistical model involving a combinatorial space

### Motivation

To motivate the model we explore in this question, consider a sport such as golf or track and fields where the players do not interact. Suppose we follow five players repetitively competing against each other. Let us model each player with an inherent unobserved strength (i.e. a mean parameter for each player) and an inherent performance variability (a variance parameter for each player). We will use the following simplistic model:

- The weakest player has a mean uniformly distributed between zero and one.
- Compared to the weakest, the second weakest player's mean is higher by an increment uniformly distributed between zero and one.
- Compared to the second weakest, the third weakest player's mean is higher by an increment uniformly distributed between zero and one.
- Etc.
- All the variances are a priori exponentially distributed with rate 10.0.

Then each year, the five players compete agains each other. Each player's score is normally distributed with mean and variance given by its individual parameter. However, let us say we only observe the shuffled scores, i.e. we do not observe which player has which score.

The players compete during 20 games. Each game is a shuffled set of five scores. Assume the player's underlying parameters do not interact or change over time. 


### Implementation

Implement in ``PermutedClustering.bl`` a model in Blang for the problem described above. 


### Test your implementation

We would like to test this model as well, but unfortunately, since it contains continuous random variables, testing it is slightly more tricky. We can test the discrete parts by fixing the value of the continuous random variables to arbitrary values (this is done in ``TestPermutedClusteringFixedParameters``, effectively testing the permutation sampler on a non-uniform distribution), but we would also like to test the full model holistically. 

To do so, we will use the Exact Invariance Test. Read the relevant section at this address: [https://www.stat.ubc.ca/~bouchard/blang/Testing_Blang_models.html](https://www.stat.ubc.ca/~bouchard/blang/Testing_Blang_models.html). 

Read and run the test in ``TestPermutedClustering``. 


### Run your model on synthetic data

To test your model on some synthetic data, use the nextflow script provided in the repository. Read the nextflow script to understand how it works. After running it, you will find a subdirectory inside ``nextflow/deliverables`` with the following plots:

- ``data.pdf``: all the generated scores for all the games.
- ``means.pdf``: trace plot for the mean parameters.
- ``permutations-truth.pdf``: permutations used to generate the data (held-out during inference).
- ``permutations-posterior.pdf``: posterior statistics on inferred permutations.

Attach the last plot to your report. 


## Optional question

Note that this question can become the seed of a potential project.

Pick another combinatorial space involved in models related to your research. Some suggestions include:

- Unrooted phylogenetic trees.
- Partitions.
- Multiple sequence alignments.
- Hamiltonian path.

### Datastructure and associated sampler

Create a new package containing a class implementing a datastructure for the combinatorial space of interest. You may want to look at ``Permutation.xtend`` for inspiration.

You will also need to write a sampler. Review what you have done in ``PermutationSampler.java`` to guide you. 


### Prior

Create a prior for the datastructure. Look at ``UniformPermutation.bl`` as a guide. 


### Test

Check what you have done so far using a test based on discrete Markov chain theory as in ``TestPermutation.xtend``. Create the test in a mirror package in the test directory.


### Model

Build a model by combining the prior with a likelihood, in the spirit of ``PermutedClustering.bl``. 


### Test, continued

Test the model using an exact invariance test. Review ``TestPermutedClustering.xtend``.


### Application to synthetic or real data. 

Use a new nextflow pipeline based on ``permuted-clustering.nf``.


## Reminder

Do not forget to push to github at the end and to check the Travis tests behave as expected (if they don't you should get a email). 


