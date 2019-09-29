namespace Photohack.Models
{
    /// <summary>
    /// Photo api configurations
    /// </summary>
    public static class PhotoApiConfigs
    {
        /// <summary>
        /// The client name
        /// </summary>
        public const string ClientName = "photolab";

        /// <summary>
        /// The request URI
        /// </summary>
        public const string RequestUri = "template_process.php";

        /// <summary>
        /// The application-form type
        /// </summary>
        public const string ApplicationForm = "application/x-www-form-urlencoded";

        /// <summary>
        /// The image URL key name
        /// </summary>
        public const string ImageUrlKeyName = "image_url[1]";

        /// <summary>
        /// The template key name
        /// </summary>
        public const string TemplateKeyName = "template_name";
    }
}
