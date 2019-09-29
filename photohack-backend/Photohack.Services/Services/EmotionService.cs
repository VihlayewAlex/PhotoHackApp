using Microsoft.Extensions.Options;
using Photohack.Models;
using System.Collections.Generic;
using System.Net.Http;
using System.Threading.Tasks;

namespace Photohack.Services
{
    /// <summary>
    /// Emotion service.
    /// </summary>
    /// <seealso cref="Photohack.Services.IEmotionService" />
    public class EmotionService : IEmotionService
    {
        /// <summary>
        /// The configuration
        /// </summary>
        private readonly ParallelDotsConfiguration _configuration;

        /// <summary>
        /// The client factory
        /// </summary>
        private readonly IHttpClientFactory _clientFactory;

        /// <summary>
        /// Initializes a new instance of the <see cref="EmotionService"/> class.
        /// </summary>
        /// <param name="clientFactory">The client factory.</param>
        /// <param name="configuration">The configuration.</param>
        public EmotionService(IHttpClientFactory clientFactory, IOptions<ParallelDotsConfiguration> configuration)
        {
            _clientFactory = clientFactory;
            _configuration = configuration.Value;
        }

        /// <summary>
        /// Gets the emotion asynchronously.
        /// </summary>
        /// <param name="text">The text.</param>
        /// <returns>
        /// The emotion value.
        /// </returns>
        /// <exception cref="EmotionException">
        /// If nothing was found.
        /// </exception>
        public async Task<int> GetEmotionAsync(string text)
        {
            var client = _clientFactory.CreateClient(EmotionApiConfigs.ClientName);

            var keys = new List<KeyValuePair<string, string>>
            {
                new KeyValuePair<string, string>(EmotionApiConfigs.ApiKeyName, _configuration.ApiKey),
                new KeyValuePair<string, string>(EmotionApiConfigs.TextKeyName, text)
            };

            var request = new HttpRequestMessage(HttpMethod.Post, EmotionApiConfigs.RequestUri) { Content = new FormUrlEncodedContent(keys) };
            var response = await client.SendAsync(request);

            if (response.IsSuccessStatusCode)
            {
                var result = await response.Content.ReadAsAsync<EmotionStatistics>();

                if (result?.Emotion == null)
                {
                    throw new EmotionException(EmotionErrorCode.NothingFound);
                }

                var max = result.Emotion.Angry;
                var maxEmotion = EmotionEnum.Angry;

                GetMax(ref max, result.Emotion.Excited, ref maxEmotion, EmotionEnum.Excited);
                GetMax(ref max, result.Emotion.Fear, ref maxEmotion, EmotionEnum.Fear);
                GetMax(ref max, result.Emotion.Happy, ref maxEmotion, EmotionEnum.Happy);
                GetMax(ref max, result.Emotion.Sad, ref maxEmotion, EmotionEnum.Sad);
                GetMax(ref max, result.Emotion.Indifferent, ref maxEmotion, EmotionEnum.Indifferent);

                return (int)maxEmotion;
            }

            throw new EmotionException(EmotionErrorCode.NothingFound);
        }

        /// <summary>
        /// Gets the maximum.
        /// </summary>
        /// <param name="currentValue">The current value.</param>
        /// <param name="comparedValue">The compared value.</param>
        /// <param name="currentNumber">The current number.</param>
        /// <param name="comparedNumber">The compared number.</param>
        private void GetMax(ref decimal currentValue, decimal comparedValue, ref EmotionEnum currentNumber, EmotionEnum comparedNumber)
        {
            if (currentValue < comparedValue)
            {
                currentValue = comparedValue;
                currentNumber = comparedNumber;
            }
        }
    }
}
