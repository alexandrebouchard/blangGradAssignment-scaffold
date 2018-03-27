package matchings

import blang.validation.ExactInvarianceTest
import org.junit.Test
import blang.validation.Instance
import blang.validation.DeterminismTest

class TestPermutedClustering {
  
  val static PermutedClustering clusteringModel = new PermutedClustering.Builder()
    .setGroupSize(3)
    .setNGroups(2) 
    .build
  val static test = new ExactInvarianceTest => [
    nPosteriorSamplesPerIndep = 1_000
  ]
  val static instance = new Instance(
    clusteringModel,
    // Test functions:
    [means.get(0).doubleValue],
    [variances.get(0).doubleValue],
    [observations.get(0,0)],
    [means.get(permutations.get(0).getConnections.get(0)).doubleValue]  
  )
  
  @Test
  def void testKSInvariance() {
    test.add(instance)
    test.check
  }
  
  @Test
  def void testDeterminism() {
    new DeterminismTest => [
      check(instance)
    ]
  }
}
