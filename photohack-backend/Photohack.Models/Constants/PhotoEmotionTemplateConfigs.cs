using System.Collections.Generic;

namespace Photohack.Models
{
    /// <summary>
    /// Photo-emotions template configurations
    /// </summary>
    public static class PhotoEmotionTemplateConfigs
    {
        /// <summary>
        /// The default
        /// </summary>
        public static readonly int Default = 2708;

        /// <summary>
        /// The emotion first template
        /// </summary>
        public static readonly Dictionary<int, int> EmotionFirstTemplate = new Dictionary<int, int>
        {
            {(int)EmotionEnum.Happy, 1630 },
            {(int)EmotionEnum.Sad, 1629 },
            {(int)EmotionEnum.Angry, 2085 },
            {(int)EmotionEnum.Excited, 2091 }
        };

        /// <summary>
        /// The emotion last template
        /// </summary>
        public static readonly Dictionary<int, int> EmotionLastTemplate = new Dictionary<int, int>
        {
            {(int)EmotionEnum.Angry, 1191},
            {(int)EmotionEnum.Sad, 2337 },
            {(int)EmotionEnum.Excited, 410 }
        };
    }
}
