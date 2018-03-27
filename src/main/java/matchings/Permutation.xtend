package matchings

import org.eclipse.xtend.lib.annotations.Data
import blang.mcmc.Samplers
import java.util.Random
import static java.util.Collections.sort
import static java.util.Collections.shuffle

/**
 * A permutation or equivalently, a bipartite perfect 
 * matching.
 * 
 * The annotation "@Samplers" links the data type with the appropriate sampler. 
 * 
 * The annotation "@Data" is not related to data in the statistical 
 * sense but rather read as 'data class', meaning that .equals, .hashcode 
 * are automatically implemented, as well as other nice defaults 
 * (see the xtend documentation for details). 
 */
@Samplers(PermutationSampler)
@Data class Permutation extends MatchingBase {
  /**
   * Sample an independent uniform permutation in place.
   */
  def void sampleUniform(Random random) { 
    sort(connections) // sort first to make independent from the current config. 
    shuffle(connections, random)
  }
}
