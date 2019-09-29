using System.Threading.Tasks;

namespace Photohack.Services
{
    /// <summary>
    /// Emotion service interface
    /// </summary>
    public interface IEmotionService
    {
        /// <summary>
        /// Gets the emotion asynchronously.
        /// </summary>
        /// <param name="text">The text.</param>
        /// <returns>
        /// The emotion value.
        /// </returns>
        Task<int> GetEmotionAsync(string text);
    }
}
