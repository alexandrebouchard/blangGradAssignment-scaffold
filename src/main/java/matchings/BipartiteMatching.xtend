package matchings

import org.eclipse.xtend.lib.annotations.Data
import java.util.List
import java.util.Random

import static java.util.Collections.sort
import static java.util.Collections.shuffle

import static extension blang.distributions.Generators.*
import static blang.types.StaticUtils.*
import bayonet.distributions.Multinomial
import blang.mcmc.Samplers
import java.util.Set
import java.util.ArrayList

/**
 * We use the same representation as Permutation.xtend, but now 
 * allow the links stored in the field "List<Integer> connections" 
 * to contain a special value, FREE = -1, which means the vertex 
 * is not connected to anything.
 */
@Samplers(BipartiteMatchingSampler)
@Data class BipartiteMatching extends MatchingBase {
  
  val public static int FREE = -1
  
  new (int componentSize) {
    super(componentSize)
    sizeProbabilities = normalizations(componentSize)
    logNormalization = Multinomial.expNormalize(sizeProbabilities)
  }
  
  /**
   * The list of vertices that are free (unlinked) in the first connected 
   * component.
   */
  def List<Integer> free1() {
    val ArrayList<Integer> result = new ArrayList
    for (int i : 0 ..< componentSize)
      if (connections.get(i) == FREE)
        result.add(i)
    return result
  }
  
  /**
   * The list of vertices that are free (unlinked) in the second connected 
   * component (in an arbitrary but fixed order).
   */
  def List<Integer> free2() {
    val Set<Integer> result = (0 ..< componentSize).toSet
    result.removeAll(connections)
    return new ArrayList(result)
  }
  
  def void sampleUniform(Random random) {
    sort(connections)
    val int size = random.categorical(sizeProbabilities)
    val List<Integer> occupied = random.permutation(componentSize, size)
    val List<Integer> newConnections = random.permutation(componentSize, size)
    for (var int i = 0; i < componentSize; i++)
      connections.set(i, matchings.BipartiteMatching.FREE)
    for (var int j = 0; j < size; j++) 
      connections.set(occupied.get(j), newConnections.get(j))
  }
  val double logNormalization
  val double [] sizeProbabilities
  
  def private double [] normalizations(int nObject) {
    val double [] result = newDoubleArrayOfSize(nObject + 1)
    for (var int size = 0; size <= nObject; size++)
      result.set(size, 2.0 * logFactorial(nObject) - logFactorial(size) - 2.0 * logFactorial(nObject - size))
    return result
  }
  
  def static List<Integer> permutation(Random rand, int n, int k) {
    val List<Integer> result = (0 ..< n).toList
    shuffle(result, rand)
    return result.subList(0, k)
  }
}
