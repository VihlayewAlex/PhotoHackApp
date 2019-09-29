using System.Collections.Generic;

namespace Photohack.Models
{
    /// <summary>
    /// Music track data
    /// </summary>
    public class MusicTrack
    {
        /// <summary>
        /// Gets or sets the data.
        /// </summary>
        /// <value>
        /// The data.
        /// </value>
        public List<Track> Data { get; set; }

        /// <summary>
        /// Track class.
        /// </summary>
        public class Track
        {
            /// <summary>
            /// Gets or sets the identifier.
            /// </summary>
            /// <value>
            /// The identifier.
            /// </value>
            public long Id { get; set; }

            /// <summary>
            /// Gets or sets the title.
            /// </summary>
            /// <value>
            /// The title.
            /// </value>
            public string Title { get; set; }

            /// <summary>
            /// Gets or sets the preview.
            /// </summary>
            /// <value>
            /// The preview.
            /// </value>
            public string Preview { get; set; }

            /// <summary>
            /// Gets or sets the artist.
            /// </summary>
            /// <value>
            /// The artist.
            /// </value>
            public ArtistInfo Artist { get; set; }

            /// <summary>
            /// Artist information class
            /// </summary>
            public class ArtistInfo
            {
                /// <summary>
                /// Gets or sets the identifier.
                /// </summary>
                /// <value>
                /// The identifier.
                /// </value>
                public long Id { get; set; }

                /// <summary>
                /// Gets or sets the name.
                /// </summary>
                /// <value>
                /// The name.
                /// </value>
                public string Name { get; set; }

                /// <summary>
                /// Gets or sets the picture.
                /// </summary>
                /// <value>
                /// The picture.
                /// </value>
                public string Picture { get; set; }
            }
        }
    }
}
