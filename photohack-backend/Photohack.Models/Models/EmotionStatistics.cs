namespace Photohack.Models
{
    /// <summary>
    /// Emotion statistics model
    /// </summary>
    public class EmotionStatistics
    {
        /// <summary>
        /// Gets or sets the emotion.
        /// </summary>
        /// <value>
        /// The emotion.
        /// </value>
        public Info Emotion { get; set; }

        /// <summary>
        /// Detailed information about emotions.
        /// </summary>
        public class Info
        {
            /// <summary>
            /// Gets or sets the happy.
            /// </summary>
            /// <value>
            /// The happy.
            /// </value>
            public decimal Happy { get; set; }

            /// <summary>
            /// Gets or sets the sad.
            /// </summary>
            /// <value>
            /// The sad.
            /// </value>
            public decimal Sad { get; set; }

            /// <summary>
            /// Gets or sets the angry.
            /// </summary>
            /// <value>
            /// The angry.
            /// </value>
            public decimal Angry { get; set; }

            /// <summary>
            /// Gets or sets the fear.
            /// </summary>
            /// <value>
            /// The fear.
            /// </value>
            public decimal Fear { get; set; }

            /// <summary>
            /// Gets or sets the excited.
            /// </summary>
            /// <value>
            /// The excited.
            /// </value>
            public decimal Excited { get; set; }

            /// <summary>
            /// Gets or sets the indifferent.
            /// </summary>
            /// <value>
            /// The indifferent.
            /// </value>
            public decimal Indifferent { get; set; }
        }
    }
}
