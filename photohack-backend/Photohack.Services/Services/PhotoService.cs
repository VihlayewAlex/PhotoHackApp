using Microsoft.AspNetCore.Hosting;
using Photohack.Models;
using System;
using System.Collections.Generic;
using System.Drawing;
using System.IO;
using System.Net.Http;
using System.Threading.Tasks;

namespace Photohack.Services
{
    /// <summary>
    /// Photo service
    /// </summary>
    /// <seealso cref="Photohack.Services.IPhotoService" />
    public class PhotoService : IPhotoService
    {
        /// <summary>
        /// The client factory
        /// </summary>
        private readonly IHttpClientFactory _clientFactory;

        /// <summary>
        /// The environment variable
        /// </summary>
        private readonly IHostingEnvironment _env;

        /// <summary>
        /// The home images URL
        /// </summary>
        private const string HomeImagesUrl = "https://crazyfacemessenger.azurewebsites.net/images/";

        /// <summary>
        /// Initializes a new instance of the <see cref="PhotoService"/> class.
        /// </summary>
        /// <param name="clientFactory">The client factory.</param>
        /// <param name="env">The env.</param>
        public PhotoService(IHttpClientFactory clientFactory, IHostingEnvironment env)
        {
            _clientFactory = clientFactory;
            _env = env;
        }

        /// <summary>
        /// Gets the filter.
        /// </summary>
        /// <param name="emotion">The emotion.</param>
        /// <param name="bytes">The bytes (image).</param>
        /// <returns>
        /// Links of photos with filters.
        /// </returns>
        public async Task<string[]> GetFilter(int emotion, byte[] bytes)
        {
            var name = SavePhoto(bytes);

            var links = await ProcessPhotoAsync(emotion, name);

            return links;
        }

        /// <summary>
        /// Processes the photo asynchronously.
        /// </summary>
        /// <param name="emotion">The emotion.</param>
        /// <param name="name">The name.</param>
        /// <returns>
        /// Array of links
        /// </returns>
        private async Task<string[]> ProcessPhotoAsync(int emotion, string name)
        {
            List<string> result = new List<string>();

            var url = HomeImagesUrl + name;

            if (PhotoEmotionTemplateConfigs.EmotionFirstTemplate.ContainsKey(emotion))
            {
                url = await GetEffectPhotoAsync(url, PhotoEmotionTemplateConfigs.EmotionFirstTemplate[emotion]);

                result.Add(url);
            }

            var additionalFilter = url;

            if (PhotoEmotionTemplateConfigs.EmotionLastTemplate.ContainsKey(emotion))
            {
                additionalFilter = await GetEffectPhotoAsync(additionalFilter, PhotoEmotionTemplateConfigs.EmotionLastTemplate[emotion]);

                result.Add(additionalFilter);
            }

            var frameFilter = await GetEffectPhotoAsync(additionalFilter, PhotoEmotionTemplateConfigs.Default);

            result.Add(frameFilter);

            return result.ToArray();
        }

        /// <summary>
        /// Gets the effect photo asynchronously.
        /// </summary>
        /// <param name="url">The URL.</param>
        /// <param name="id">The identifier.</param>
        /// <returns>
        /// The link to a new photo.
        /// </returns>
        private async Task<string> GetEffectPhotoAsync(string url, int id)
        {
            var client = _clientFactory.CreateClient(PhotoApiConfigs.ClientName);

            var keys = new List<KeyValuePair<string, string>>
            {
                new KeyValuePair<string, string>(PhotoApiConfigs.ImageUrlKeyName, url),
                new KeyValuePair<string, string>(PhotoApiConfigs.TemplateKeyName, id.ToString())
            };

            var request = new HttpRequestMessage(HttpMethod.Post, PhotoApiConfigs.RequestUri) { Content = new FormUrlEncodedContent(keys) };
            var response = await client.SendAsync(request);

            if (response.IsSuccessStatusCode)
            {
                return await response.Content.ReadAsStringAsync();
            }

            return string.Empty;
        }

        /// <summary>
        /// Saves the photo.
        /// </summary>
        /// <param name="bytes">The bytes.</param>
        /// <returns>
        /// Name of photo.
        /// </returns>
        private string SavePhoto(byte[] bytes)
        {
            var webRoot = _env.WebRootPath;
            var PathWithFolderName = System.IO.Path.Combine(webRoot, "images\\");

            var name = Guid.NewGuid().ToString() + ".jpg";
            Image image;
            using (MemoryStream ms = new MemoryStream(bytes))
            {
                image = Image.FromStream(ms);

                image.Save(PathWithFolderName + name);
            }

            return name;
        }
    }
}
