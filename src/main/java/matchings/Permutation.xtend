package matchings

import org.eclipse.xtend.lib.annotations.Data
import java.util.List
import blang.mcmc.Samplers
import java.util.Random
import static java.util.Collections.sort
import static java.util.Collections.shuffle
import blang.inits.experiments.tabwriters.TidilySerializable
import blang.inits.experiments.tabwriters.TidySerializer.Context

/**
 * A permutation on nObjects. 
 * 
 * The annotation links the data type with the appropriate sampler. 
 * 
 * The annotation @Data is not related to data in the statistical 
 * sense but rather read as 'data class', meaning that .equals, .hashcode 
 * are automatically implemented, as well as other nice defaults 
 * (see the xtend documentation for details). 
 */
@Samplers(PermutationSampler)
@Data class Permutation implements TidilySerializable {
  val List<Integer> indices
  
  new (int nObjects) {
    indices = (0 ..< nObjects).toList
  }
  def int nObjects() { 
    return indices.size
  } 
  override String toString() { 
    return indices.toString
  } 
  /**
   * Sample an independent uniform permutation in place.
   */
  def void sampleUniform(Random random) { 
    sort(indices) // sort first to make independent from the current config. 
    shuffle(indices, random)
  }
  /**
   * Used to output samples into a tidy format. 
   */
  override void serialize(Context context) {
    for (int i : 0 ..< nObjects)
      context.recurse(indices.get(i), "permutation_index", i)
  }
}
