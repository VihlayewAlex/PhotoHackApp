using Photohack.Models;
using System.Threading.Tasks;

namespace Photohack.Services
{
    /// <summary>
    /// Music service interface.
    /// </summary>
    public interface IMusicService
    {
        /// <summary>
        /// Gets the music links asynchronously.
        /// </summary>
        /// <param name="phrase">The phrase.</param>
        /// <param name="words">The key words.</param>
        /// <returns>
        /// Music track data.
        /// </returns>
        Task<MusicTrack> GetMusicLinksAsync(string phrase, string words);
    }
}
