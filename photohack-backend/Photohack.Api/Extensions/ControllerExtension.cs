//-----------------------------------------------------------------------
// <copyright file="ControllerExtension.cs" company="Space Rabbits">
//     Copyright (c) Space Rabbits. All rights reserved.
// </copyright>
//-----------------------------------------------------------------------

using System;
using System.Diagnostics.CodeAnalysis;
using Photohack.Api.Models;
using Microsoft.AspNetCore.Mvc;

namespace Photohack.Api.Extensions
{
    /// <summary>
    /// The extension class for controllers.
    /// </summary>
    public static class ControllerExtension
    {
        /// <summary>
        /// The wrapper for responses.
        /// </summary>
        /// <param name="controller">The controller.</param>
        /// <returns>The json response.</returns>
        [SuppressMessage("StyleCop.CSharp.DocumentationRules", "SA1650:ElementDocumentationMustBeSpelledCorrectly", Justification = "Reviewed.")]
        public static JsonResult JsonApi(this ControllerBase controller)
        {
            ApiResponse response = new ApiResponse
            {
                Result = true
            };

            JsonResult result = new JsonResult(response);

            return result;
        }

        /// <summary>
        /// The wrapper for responses.
        /// </summary>
        /// <param name="controller">The controller.</param>
        /// <param name="data">The data.</param>
        /// <returns>The json response.</returns>
        [SuppressMessage("StyleCop.CSharp.DocumentationRules", "SA1650:ElementDocumentationMustBeSpelledCorrectly", Justification = "Reviewed.")]
        public static JsonResult JsonApi(this ControllerBase controller, object data)
        {
            ApiResponse response = new ApiResponse
            {
                Data = data,
                Result = true
            };

            JsonResult result = new JsonResult(response);

            return result;
        }

        /// <summary>
        /// The wrapper for responses.
        /// </summary>
        /// <param name="controller">The controller.</param>
        /// <param name="exception">The exception.</param>
        /// <returns>The json response.</returns>
        [SuppressMessage("StyleCop.CSharp.DocumentationRules", "SA1650:ElementDocumentationMustBeSpelledCorrectly", Justification = "Reviewed.")]
        public static JsonResult JsonApi(this ControllerBase controller, Exception exception)
        {
            ApiResponse response = new ApiResponse
            {
                Result = false,
                Errors = new string[] { exception.Message }
            };

            JsonResult result = new JsonResult(response);

            return result;
        }
    }
}
