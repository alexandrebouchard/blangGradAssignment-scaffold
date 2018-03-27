package matchings

import matchings.UniformPermutation
import blang.validation.DiscreteMCTest
import blang.runtime.SampledModel
import org.junit.Test
import matchings.Permutation
import java.util.ArrayList
import static org.apache.commons.math3.util.CombinatoricsUtils.factorial

class TestPermutation {
  val static int size = 5
  val static UniformPermutation unifPermutationModel = new UniformPermutation.Builder().setPermutation(new Permutation(size)).build
  val static DiscreteMCTest test = 
    new DiscreteMCTest(
      new SampledModel(unifPermutationModel), 
      [new ArrayList((model as UniformPermutation).permutation.getConnections)]
    )
  
  @Test 
  def void stateSize() {
    test.checkStateSpaceSize(factorial(size) as int)
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
