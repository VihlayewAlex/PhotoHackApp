using System.Threading.Tasks;

namespace Photohack.Services
{
    /// <summary>
    /// Photo service interface
    /// </summary>
    public interface IPhotoService
    {
        /// <summary>
        /// Gets the filter.
        /// </summary>
        /// <param name="emotion">The emotion.</param>
        /// <param name="bytes">The bytes (image).</param>
        /// <returns>
        /// Links of photos with filters.
        /// </returns>
        Task<string[]> GetFilter(int emotion, byte[] bytes);
    }
}
