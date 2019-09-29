namespace Photohack.Api
{
    /// <summary>
    /// GetPhoto-request model
    /// </summary>
    public class GetPhotoRequest
    {
        /// <summary>
        /// Gets or sets the emotion.
        /// </summary>
        /// <value>
        /// The emotion.
        /// </value>
        public int Emotion { get; set; }

        /// <summary>
        /// Gets or sets the photo.
        /// </summary>
        /// <value>
        /// The photo.
        /// </value>
        public byte[] Photo { get; set; }
    }
}
