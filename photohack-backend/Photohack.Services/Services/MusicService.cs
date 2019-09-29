using Photohack.Models;
using System;
using System.Net.Http;
using System.Threading.Tasks;

namespace Photohack.Services
{
    /// <summary>
    /// Music service
    /// </summary>
    /// <seealso cref="Photohack.Services.IMusicService" />
    public class MusicService : IMusicService
    {
        /// <summary>
        /// The client factory
        /// </summary>
        private readonly IHttpClientFactory _clientFactory;

        /// <summary>
        /// The delimeter
        /// </summary>
        private const char Delimeter = ' ';

        /// <summary>
        /// Initializes a new instance of the <see cref="MusicService"/> class.
        /// </summary>
        /// <param name="clientFactory">The client factory.</param>
        public MusicService(IHttpClientFactory clientFactory)
        {
            _clientFactory = clientFactory;
        }

        /// <summary>
        /// Gets the music links asynchronously.
        /// </summary>
        /// <param name="phrase">The phrase.</param>
        /// <param name="words">The key words.</param>
        /// <returns>
        /// Music track data.
        /// </returns>
        /// <exception cref="MusicException">
        /// If nothing was found
        /// </exception>
        public async Task<MusicTrack> GetMusicLinksAsync(string phrase, string words)
        {
            MusicTrack result = null;

            while (phrase?.Length > 0 && (result?.Data == null || result.Data.Count == 0))
            {
                result = await GetTracksAsync(phrase);

                phrase = phrase.Substring(0, Math.Max(0, phrase.LastIndexOf(Delimeter)));
            }

            if (result?.Data != null && result.Data.Count > 0)
            {
                return result;
            }

            if (words?.Length > 0)
            {
                foreach (var word in words.Split(Delimeter))
                {
                    result = await GetTracksAsync(word);

                    if (result?.Data != null && result.Data.Count > 0)
                    {
                        return result;
                    }
                }
            }

            throw new MusicException(MusicErrorCode.NothingFound);
        }

        /// <summary>
        /// Gets the tracks asynchronously.
        /// </summary>
        /// <param name="phrase">The phrase.</param>
        /// <returns>
        /// Music tracks.
        /// </returns>
        private async Task<MusicTrack> GetTracksAsync(string phrase)
        {
            var client = _clientFactory.CreateClient(MusicApiConfigs.ClientName);

            var response = await client.GetAsync(MusicApiConfigs.RequestUri + phrase);

            if (response.IsSuccessStatusCode)
            {
                return await response.Content.ReadAsAsync<MusicTrack>();
            }
            else
            {
                return null;
            }
        }
    }
}
