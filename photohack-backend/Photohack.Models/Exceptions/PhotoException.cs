using System;
using System.Collections.Generic;

namespace Photohack.Models
{
    /// <summary>
    /// Photo exception.
    /// </summary>
    /// <seealso cref="System.Exception" />
    public class PhotoException : Exception
    {
        /// <summary>
        /// The unexpected error
        /// </summary>
        private const string Unexpected = "Unexpected error.";

        /// <summary>
        /// Mapping the error codes to the default error messages.
        /// </summary>
        private static Dictionary<PhotoErrorCode, string> errorCodeToMessage = new Dictionary<PhotoErrorCode, string>
        {
            { PhotoErrorCode.NullArgument, "Oops... Please, tell me something:)" },
            { PhotoErrorCode.NothingFound, "I couldn't find anything:(" }
        };

        /// <summary>
        /// Initializes a new instance of the <see cref="PhotoException"/> class.
        /// </summary>
        /// <param name="errorCode">The error code.</param>
        public PhotoException(PhotoErrorCode errorCode)
            : base(GetErrorMessage(errorCode))
        {
            this.ErrorCode = errorCode;
        }

        /// <summary>
        /// Gets the error code.
        /// </summary>
        /// <value>
        /// The error code.
        /// </value>
        public PhotoErrorCode ErrorCode { get; private set; }

        /// <summary>
        /// Gets the error message.
        /// </summary>
        /// <param name="errorCode">The error code.</param>
        /// <returns>
        /// The error message text.
        /// </returns>
        private static string GetErrorMessage(PhotoErrorCode errorCode)
        {
            string message = errorCodeToMessage.ContainsKey(errorCode)
                ? errorCodeToMessage[errorCode] : Unexpected;

            return message;
        }
    }
}
