package matchings

import blang.validation.DiscreteMCTest
import blang.runtime.SampledModel
import org.junit.Test
import java.util.ArrayList

class TestBipartiteMatching {
  val static int size = 5
  val static UniformBipartiteMatching unifMatchingModel = new UniformBipartiteMatching.Builder().setMatching(new BipartiteMatching(size)).build
  val static DiscreteMCTest test = 
    new DiscreteMCTest(
      new SampledModel(unifMatchingModel), 
      [new ArrayList((model as UniformBipartiteMatching).matching.getConnections)]
    )
  
  @Test
  def void invariance() {
    test.checkInvariance
  }
  
  @Test
  def void irreducibility() {
    test.checkIrreducibility
  }
}
