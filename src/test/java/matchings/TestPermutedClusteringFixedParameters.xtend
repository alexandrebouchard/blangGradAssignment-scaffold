package matchings

import static blang.types.StaticUtils.*
import blang.runtime.SampledModel
import blang.validation.DiscreteMCTest
import com.rits.cloning.Cloner
import org.junit.Test
import static org.apache.commons.math3.util.CombinatoricsUtils.factorial
import static java.lang.Math.pow
import blang.runtime.internals.objectgraph.GraphAnalysis
import blang.runtime.Observations
import blang.types.ExtensionUtils

class TestPermutedClusteringFixedParameters {
  
    val static emissions = {
    val result = latentMatrix(2, 3)
    ExtensionUtils.setTo(result, 
      fixedMatrix(#[
        #[1.1, 2.3, 2.1],
        #[-0.2, 1.4, -0.01]
      ])
    )
    result
  }
  val static PermutedClustering clusteringModel = new PermutedClustering.Builder()
    .setGroupSize(3)
    .setNGroups(2)
    .setMeans(fixedRealList(0.5, 0.7, 1.2))
    .setVariances(fixedRealList(0.2, 0.1, 0.15))
    .setObservations(emissions)
    .build
  val static observations = {
    val Observations result = new Observations
    result.markAsObserved(emissions)
    result
  }
  val static DiscreteMCTest test = 
    new DiscreteMCTest(
      new SampledModel(new GraphAnalysis(clusteringModel, observations)),
      [
        val PermutedClustering clustering = model as PermutedClustering
        return new Cloner().deepClone(clustering.permutations)
      ]
    ) 
  
  @Test 
  def void stateSize() {
    test.checkStateSpaceSize(pow(factorial(3), 2) as int)
  }
  
  @Test
  def void invariance() {
    test.checkInvariance
  }
  
  @Test
  def void irreducibility() {
    test.checkIrreducibility
  }
  

}
