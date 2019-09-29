using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Photohack.Api.Extensions;
using Photohack.Models;
using Photohack.Services;

namespace Photohack.Api.Controllers
{
    /// <summary>
    /// Image template controller
    /// </summary>
    /// <seealso cref="Microsoft.AspNetCore.Mvc.ControllerBase" />
    [Route("api/[controller]")]
    [ApiController]
    public class ImageTemplateController : ControllerBase
    {
        /// <summary>
        /// The music service
        /// </summary>
        public readonly IMusicService _musicService;

        /// <summary>
        /// The emotion service
        /// </summary>
        public readonly IEmotionService _emotionService;

        /// <summary>
        /// The photo service
        /// </summary>
        public readonly IPhotoService _photoService;

        /// <summary>
        /// Initializes a new instance of the <see cref="ImageTemplateController"/> class.
        /// </summary>
        /// <param name="musicService">The music service.</param>
        /// <param name="emotionService">The emotion service.</param>
        /// <param name="photoService">The photo service.</param>
        public ImageTemplateController(IMusicService musicService, IEmotionService emotionService, IPhotoService photoService)
        {
            _musicService = musicService;
            _emotionService = emotionService;
            _photoService = photoService;
        }

        /// <summary>
        /// Gets tracks (depends on the whole phrase and main words).
        /// </summary>
        /// <param name="phrase">The whole phrase.</param>
        /// <param name="words">The words, separated with spaces.</param>
        /// <returns>List of tracks.</returns>
        /// <exception cref="ArgumentNullException">
        /// If phrase and words are null.
        /// </exception>
        [HttpGet]
        public async Task<JsonResult> GetMusic(string phrase, string words)
        {
            if (string.IsNullOrWhiteSpace(phrase) && (words == null || words.Count() == 0))
            {
                return this.JsonApi(new MusicException(MusicErrorCode.NullArgument));
            }

            try
            {
                var tracks = await _musicService.GetMusicLinksAsync(phrase, words);

                return this.JsonApi(tracks.Data.Take(3));
            }
            catch (MusicException exception)
            {
                return this.JsonApi(exception);
            }
        }

        /// <summary>
        /// Gets the emotion.
        /// </summary>
        /// <param name="text">The text.</param>
        /// <returns>
        /// The closest emotion
        /// </returns>
        [HttpGet("emotion")]
        public async Task<JsonResult> GetEmotion(string text)
        {
            if (string.IsNullOrWhiteSpace(text))
            {
                return this.JsonApi(new EmotionException(EmotionErrorCode.NullArgument));
            }

            try
            {
                int emotion = await _emotionService.GetEmotionAsync(text);

                var response = new GetEmotionResponse
                {
                    Emotion = emotion
                };

                return this.JsonApi(response);
            }
            catch (EmotionException exception)
            {
                return this.JsonApi(exception);
            }
        }

        [HttpPost("photo")]
        public async Task<JsonResult> GetPhoto([FromBody]GetPhotoRequest request)
        {
            if (request?.Photo == null)
            {
                return this.JsonApi(new PhotoException(PhotoErrorCode.NullArgument));
            }

            var links = await _photoService.GetFilter(request.Emotion, request.Photo);

            var result = new GetPhotoResponse
            {
                Links = links?.Where(x => !string.IsNullOrWhiteSpace(x)).ToArray()
            };

            return this.JsonApi(result);
        }
    }
}
